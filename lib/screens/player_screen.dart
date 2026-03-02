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

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<PlayerProvider>(context, listen: false);
    _currentIndex = widget.initialIndex;
    _loadAndPlay();
  }

  Future<void> _loadAndPlay() async {
    try {
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
            color: Colors.white.withValues(alpha: 0.1),
            shape: const CircleBorder(),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: r.s(28)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: r.s(20)),
            child: IconButton(
              icon: Icon(Icons.more_vert_rounded, color: Colors.white, size: r.s(24)),
              onPressed: () {},
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
                        Colors.black.withValues(alpha: 0.4),
                        AppColors.primaryGreen.withValues(alpha: 0.9),
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
                                        color: Colors.black.withValues(alpha: 0.6),
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
                                      color: Colors.white.withValues(alpha: 0.5),
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
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(r.s(48)),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: r.s(4),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: r.s(8)),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: r.s(20)),
                                      activeTrackColor: AppColors.accentGold,
                                      inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: provider.position.inSeconds.toDouble().clamp(0, provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0),
                                      max: provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0,
                                      onChanged: (value) => provider.seek(Duration(seconds: value.toInt())),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: r.s(20)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_formatDuration(provider.position), style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: r.sp(11), fontWeight: FontWeight.bold)),
                                        Text(_formatDuration(provider.duration), style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: r.sp(11), fontWeight: FontWeight.bold)),
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
                                                color: Colors.white.withValues(alpha: 0.2),
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