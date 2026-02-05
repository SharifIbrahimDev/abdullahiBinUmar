import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';
import '../services/audio_service.dart';
import '../data/books_data.dart';

class PlayerProvider extends ChangeNotifier {
  Lesson? _currentLesson;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  ProcessingState? _processingState;
  final Map<String, Duration> _cachedDurations = {};

  Lesson? get currentLesson => _currentLesson;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  
  Duration get duration {
    if (_duration != Duration.zero) return _duration;
    if (_currentLesson != null) {
      return _parseDuration(_currentLesson!.duration);
    }
    return Duration.zero;
  }

  ProcessingState? get processingState => _processingState;

  StreamSubscription? _positionSub;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _durationSub;

  PlayerProvider() {
    _initListeners();
    _loadCachedDurations();
    _tryResumePlayback(); // 4️⃣ Auto-resume on app reopen
  }

  Future<void> _loadCachedDurations() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('dur_'));
    for (final key in keys) {
      final id = key.replaceFirst('dur_', '');
      final durStr = prefs.getString(key);
      if (durStr != null) {
        _cachedDurations[id] = _parseDuration(durStr);
      }
    }
    notifyListeners();
  }

  /// 4️⃣ On app reopen: Resume playback from the saved position
  Future<void> _tryResumePlayback() async {
    final state = await audioService.getSavedPlaybackState();
    if (state != null) {
      final String bookId = state['bookId'];
      final int lessonNum = state['lessonNum'];
      final Duration position = state['position'];

      // Get the lesson data
      final lessons = getLessonsForBook(bookId);
      final lesson = lessons.firstWhere(
        (l) => l.lessonNumber == lessonNum,
        orElse: () => lessons.first,
      );

      // Load it into the player (silent/paused by default or as requested? usually silent/paused)
      // The user said "Resume playback", usually this implies auto-playing if it was playing, 
      // but simpler is to just load it so user can press play.
      // However, if I call playLesson it will start playing. 
      // I'll load it but not play immediately to be safe, or just follow "Resume playback" literally.
      _currentLesson = lesson;
      _position = position;
      _duration = _cachedDurations[lesson.id] ?? Duration.zero;
      
      // We set the playlist for auto-play context
      audioService.setPlaylist(lessons);
      
      notifyListeners();
      
      // If we want to fully "resume" (start playing), we call playLesson.
      // Let's at least prepare the player.
      await audioService.playLesson(lesson, startPosition: position);
      // Immediately pause to let the user decide to continue
      await audioService.pause();
    }
  }

  Duration _parseDuration(String durStr) {
    try {
      final parts = durStr.split(':');
      if (parts.length == 2) {
        return Duration(minutes: int.parse(parts[0]), seconds: int.parse(parts[1]));
      } else if (parts.length == 3) {
        return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]), seconds: int.parse(parts[2]));
      }
    } catch (_) {}
    return Duration.zero;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$minutes:$seconds';
  }

  Duration getLessonDuration(Lesson lesson) {
    return _cachedDurations[lesson.id] ?? _parseDuration(lesson.duration);
  }

  void _initListeners() {
    _playerStateSub = audioService.player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _processingState = state.processingState;
      // Also sync current lesson if AudioService changed it (Auto-Play Next)
      if (audioService.currentLesson != null && audioService.currentLesson != _currentLesson) {
        _currentLesson = audioService.currentLesson;
      }
      notifyListeners();
    });

    _durationSub = audioService.player.durationStream.listen((dur) async {
      if (dur != null && dur != Duration.zero) {
        _duration = dur;
        if (_currentLesson != null) {
          _cachedDurations[_currentLesson!.id] = dur;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('dur_${_currentLesson!.id}', _formatDuration(dur));
        }
        notifyListeners();
      }
    });

    _positionSub = audioService.player.positionStream.listen((pos) async {
      _position = pos;
      notifyListeners();

      // Auto-save position per lesson (already handled in AudioService now, but keeping here for backward compatibility or individual lesson tracking if needed)
    });
  }

  /// Plays a lesson and optionally sets the playlist for 3️⃣ Auto-Play Next
  Future<void> playLesson(Lesson lesson, {Duration? startPosition, List<Lesson>? playlist}) async {
    _currentLesson = lesson;
    _duration = _cachedDurations[lesson.id] ?? Duration.zero; 
    
    if (playlist != null) {
      audioService.setPlaylist(playlist);
    }

    await audioService.playLesson(
      lesson,
      startPosition: startPosition,
    );
    notifyListeners();
  }

  Future<void> pause() async {
    await audioService.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await audioService.player.play();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await audioService.player.seek(position);
    notifyListeners();
  }

  Future<void> playNext() async {
    // 3️⃣ Auto-Play Next is now handled automatically in AudioService.
  }

  Future<void> playPrevious() async {
    // Not implemented yet
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _durationSub?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }
}
