import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/player_provider.dart';
import '../constants/app_colors.dart';


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
        playlist: widget.lessons, // 3️⃣ Passes playlist for Auto-Play Next
      );
    } catch (e) {
      debugPrint('Error loading lesson: $e');
    }
  }

  // Use provider's lesson if available for auto-sync, otherwise fallback to index
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(
          child: Material(
            color: Colors.white.withValues(alpha: 0.1),
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
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
                            const SizedBox(height: 48),
                            // Album Art
                            Hero(
                              tag: 'player_art',
                              child: Center(
                                child: Container(
                                  height: (constraints.maxHeight * 0.4).clamp(200, 360),
                                  width: (constraints.maxHeight * 0.85).clamp(200, 360),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        blurRadius: 40,
                                        offset: const Offset(0, 20),
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
                            const SizedBox(height: 40),
                            // Titles
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: [
                                  Text(
                                    _displayLesson.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _displayLesson.bookTitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.5),
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _displayLesson.titleAr,
                                    style: GoogleFonts.amiri(
                                      fontSize: 32,
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            // Controls Container
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.fromLTRB(20, 48, 20, 40),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(48),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              ),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 6,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_formatDuration(provider.position), style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.bold)),
                                        Text(_formatDuration(provider.duration), style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 28),
                                        onPressed: _playPrevious,
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 24),
                                        onPressed: () => provider.seek(provider.position - const Duration(seconds: 10)),
                                      ),
                                      GestureDetector(
                                        onTap: () => isPlaying ? provider.pause() : provider.resume(),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withValues(alpha: 0.2),
                                                blurRadius: 20,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: Colors.black,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 24),
                                        onPressed: () => provider.seek(provider.position + const Duration(seconds: 10)),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 28),
                                        onPressed: _playNext,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
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