import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/player_provider.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';

class PlayerScreen extends StatefulWidget {
  final List<Lesson> lessons;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.lessons,
    required this.initialIndex,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late PlayerProvider _provider;
  late int _currentIndex;
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PlayerProvider>(context, listen: false);
    _currentIndex = widget.initialIndex;
    
    final current = _provider.currentLesson;
    final target = widget.lessons.isNotEmpty ? widget.lessons[_currentIndex] : null;

    // Only load and play if not already playing this lesson
    if (target != null && (current == null || current.id != target.id)) {
      _loadAndPlay();
    }
  }

  Future<void> _loadAndPlay() async {
    try {
      if (_currentIndex >= widget.lessons.length) return;
      final lessonToPlay = widget.lessons[_currentIndex];
      final prefs = await SharedPreferences.getInstance();
      final savedSeconds = prefs.getInt(lessonToPlay.id) ?? 0;

      await _provider.playLesson(
        lessonToPlay,
        startPosition: Duration(seconds: savedSeconds),
        playlist: widget.lessons, 
      );
    } catch (e) {
      debugPrint('Error loading lesson: $e');
    }
  }

  Lesson get _displayLesson => _provider.currentLesson ?? widget.lessons[_currentIndex];

  Future<void> _playNext() async {
    final nextIndex = widget.lessons.indexWhere((l) => l.id == _displayLesson.id) + 1;
    if (nextIndex < widget.lessons.length) {
      _currentIndex = nextIndex;
      await _loadAndPlay();
    }
  }

  Future<void> _playPrevious() async {
    final prevIndex = widget.lessons.indexWhere((l) => l.id == _displayLesson.id) - 1;
    if (prevIndex >= 0) {
      _currentIndex = prevIndex;
      await _loadAndPlay();
    }
  }

  void _showSpeedModal(BuildContext context, Responsive r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(r.s(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(r.s(32))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.s(40),
              height: r.s(4),
              margin: EdgeInsets.only(bottom: r.s(20)),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Playback Speed",
              style: GoogleFonts.outfit(
                fontSize: r.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(16)),
            Wrap(
              spacing: r.s(10),
              children: [0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                final isSelected = _provider.speed == speed;
                return ChoiceChip(
                  label: Text("${speed}x", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  onSelected: (selected) {
                    if (selected) {
                      _provider.setSpeed(speed);
                      Navigator.pop(context);
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(height: r.s(16)),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    // Dynamic album art sizing to fit all screen heights safely
    final albumArtSize = r.screenHeight * 0.35;
    final clampedSize = albumArtSize.clamp(200.0, 360.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: r.s(80),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(
          child: Material(
            color: Colors.white.withOpacity(0.1),
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: r.s(28)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: r.s(16)),
            child: Consumer<PlayerProvider>(
              builder: (context, provider, child) {
                return TextButton(
                  onPressed: () => _showSpeedModal(context, r),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.s(16))),
                    padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(6)),
                  ),
                  child: Text(
                    "${provider.speed}x",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: r.sp(13),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, child) {
          final isPlaying = provider.isPlaying;

          return Stack(
            children: [
              // Background Image with Blur
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bin_umar.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        AppColors.primaryGreen.withOpacity(0.9),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),
              // Main Content
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          children: [
                            SizedBox(height: r.s(32)),
                            // Album Art
                            Hero(
                              tag: 'player_art',
                              child: Center(
                                child: Container(
                                  height: clampedSize,
                                  width: clampedSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(r.s(40)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.6),
                                        blurRadius: r.s(40),
                                        offset: Offset(0, r.s(20)),
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/bin_umar.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: r.s(32)),
                            // Titles
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: r.s(32)),
                              child: Column(
                                children: [
                                  Text(
                                    _displayLesson.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: r.sp(22),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: r.s(8)),
                                  Text(
                                    _displayLesson.bookTitle,
                                    style: GoogleFonts.inter(
                                      fontSize: r.sp(13),
                                      color: Colors.white.withOpacity(0.5),
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: r.s(16)),
                                  Text(
                                    _displayLesson.titleAr,
                                    style: GoogleFonts.amiri(
                                      fontSize: r.sp(28),
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: r.s(32)),
                            // Controls Container
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: r.s(20)),
                              padding: EdgeInsets.fromLTRB(r.s(16), r.s(32), r.s(16), r.s(32)),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(r.s(48)),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: r.s(4),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: r.s(8)),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: r.s(20)),
                                      activeTrackColor: AppColors.accentGold,
                                      inactiveTrackColor: Colors.white.withOpacity(0.1),
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: (_dragValue ?? provider.position.inSeconds.toDouble()).clamp(0.0, provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0),
                                      max: provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0,
                                      onChanged: (value) {
                                        setState(() {
                                          _dragValue = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        provider.seek(Duration(seconds: value.toInt()));
                                        setState(() {
                                          _dragValue = null;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(_dragValue != null ? Duration(seconds: _dragValue!.toInt()) : provider.position),
                                          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: r.sp(11), fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _formatDuration(provider.duration),
                                          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: r.sp(11), fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: r.s(32)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(Icons.skip_previous_rounded, color: Colors.white, size: r.s(26)),
                                        onPressed: _playPrevious,
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(Icons.replay_10_rounded, color: Colors.white, size: r.s(22)),
                                        onPressed: () => provider.seek(provider.position - const Duration(seconds: 10)),
                                      ),
                                      GestureDetector(
                                        onTap: () => isPlaying ? provider.pause() : provider.resume(),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: r.s(64),
                                          height: r.s(64),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.2),
                                                blurRadius: r.s(20),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: Colors.black,
                                            size: r.s(42),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(Icons.forward_10_rounded, color: Colors.white, size: r.s(22)),
                                        onPressed: () => provider.seek(provider.position + const Duration(seconds: 10)),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(Icons.skip_next_rounded, color: Colors.white, size: r.s(26)),
                                        onPressed: _playNext,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: r.s(48)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}