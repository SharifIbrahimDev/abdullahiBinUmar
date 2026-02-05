import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/player_provider.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
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
                        Colors.black.withValues(alpha: 0.3),
                        const Color(0xFF1B5E20).withValues(alpha: 0.85),
                        const Color(0xFF1B5E20),
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
                            const SizedBox(height: 20),
                            // Album Art
                            Hero(
                              tag: 'player_art',
                              child: Center(
                                child: Container(
                                  height: (constraints.maxHeight * 0.4).clamp(150, 320),
                                  width: (constraints.maxHeight * 0.4).clamp(150, 320),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
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
                            const SizedBox(height: 32),
                            // Titles
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: [
                                  Text(
                                    _displayLesson.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _displayLesson.bookTitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _displayLesson.titleAr,
                                    style: GoogleFonts.amiri(
                                      fontSize: 28,
                                      color: const Color(0xFFC5A059),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),
                            // Controls
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                      activeTrackColor: const Color(0xFFC5A059),
                                      inactiveTrackColor: Colors.white24,
                                      thumbColor: Colors.white,
                                    ),
                                    child: Slider(
                                      value: provider.position.inSeconds.toDouble().clamp(0, provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0),
                                      max: provider.duration.inSeconds.toDouble() > 0 ? provider.duration.inSeconds.toDouble() : 1.0,
                                      onChanged: (value) => provider.seek(Duration(seconds: value.toInt())),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_formatDuration(provider.position), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                        Text(_formatDuration(provider.duration), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 32),
                                        onPressed: _playPrevious,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                                        onPressed: () => provider.seek(provider.position - const Duration(seconds: 10)),
                                      ),
                                      GestureDetector(
                                        onTap: () => isPlaying ? provider.pause() : provider.resume(),
                                        child: Container(
                                          width: 64,
                                          height: 64,
                                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                          child: Icon(
                                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: const Color(0xFF1B5E20),
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                                        onPressed: () => provider.seek(provider.position + const Duration(seconds: 10)),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 32),
                                        onPressed: _playNext,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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