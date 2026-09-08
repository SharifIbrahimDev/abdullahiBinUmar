import 'package:universal_io/io.dart'; // 👈 Use universal_io for File/Platform web compat
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';

// ... (baseAudioUrl)
const String baseAudioUrl = 'https://raw.githubusercontent.com/SharifIbrahimDev/abdullahiBinUmar/incremental-final/';

class AudioService {
  late AudioPlayer _player;
  final Dio _dio = Dio();
  
  bool _isInitialized = false;
  
  Lesson? _currentLesson;
  List<Lesson> _currentPlaylist = [];
  
  // Notifier for global "now playing" state
  final ValueNotifier<String?> currentPathNotifier = ValueNotifier<String?>(null);

  // 🆕 Stream for errors and messages (to show SnackBar in UI)
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  AudioPlayer get player => _player;
  Lesson? get currentLesson => _currentLesson;
  List<Lesson> get currentPlaylist => _currentPlaylist;

  Future<void> init() async {
    if (_isInitialized) return;
    _player = AudioPlayer();
    _initListeners();
    _isInitialized = true;
  }

  void _initListeners() {
    // Listen for playback completion to trigger Auto-Play Next
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handlePlaybackCompleted();
      }
    });

    // Save position periodically
    _player.positionStream.listen((pos) {
      if (_currentLesson != null && pos > Duration.zero) {
        _savePlaybackState(pos);
      }
    });
  }

  Future<void> playLesson(Lesson lesson, {Duration? startPosition}) async {
    try {
      _currentLesson = lesson;
      String effectivePath;

      final mediaItem = MediaItem(
        id: lesson.id,
        album: lesson.bookTitle,
        title: lesson.title,
        artUri: Uri.parse('asset:///assets/images/bin_umar.jpg'),
      );

      if (baseAudioUrl.isEmpty) {
        effectivePath = 'assets/audio/${lesson.audioPath}';
        if (kIsWeb && effectivePath.startsWith('assets/')) {
          effectivePath = effectivePath.replaceFirst('assets/', '');
        }
        await _player.setAudioSource(AudioSource.asset(effectivePath, tag: mediaItem));
      } else {
        final remoteUrl = Uri.encodeFull('$baseAudioUrl${lesson.audioPath}').replaceAll("'", "%27");
        debugPrint('🔍 Requested URL: $remoteUrl');

        if (kIsWeb) {
          debugPrint('🌐 Web Mode: Streaming directly...');
          await _player.setAudioSource(AudioSource.uri(Uri.parse(remoteUrl), tag: mediaItem));
        } else {
          final localFile = await _getCacheFile(lesson.audioPath);

          if (await localFile.exists()) {
            debugPrint('📂 Playing from Cache: ${localFile.path}');
            await _player.setAudioSource(AudioSource.file(localFile.path, tag: mediaItem));
          } else {
            try {
              debugPrint('📡 Streaming & Caching: $remoteUrl');
              await _player.setAudioSource(AudioSource.uri(Uri.parse(remoteUrl), tag: mediaItem));
              _downloadToCache(remoteUrl, localFile);
            } on SocketException catch (e) {
              debugPrint('❌ Offline Socket Error: $e');
              _messageController.add("No Internet Connection. Please connect to WiFi or Mobile Data.");
              return;
            } catch (e) {
              debugPrint('❌ Stream source error: $e');
              _messageController.add("Unable to play audio. Please check your network connection.");
              return;
            }
          }
        }
      }

      currentPathNotifier.value = lesson.audioPath;

      if (startPosition != null && startPosition > Duration.zero) {
        await _player.seek(startPosition);
      }
      await _player.play();
    } catch (e) {
      debugPrint('❌ Playback Error: $e');
      _messageController.add("Error playing audio: $e");
    }
  }

  /// Download file to local cache in background
  Future<void> _downloadToCache(String url, File file) async {
    try {
      await file.parent.create(recursive: true);
      await _dio.download(url, file.path);
      debugPrint('Downloaded to cache: ${file.path}');
    } catch (e) {
      debugPrint('Download to cache skipped/failed: $e');
    }
  }

  /// Get reference to cache file location
  Future<File> _getCacheFile(String relativePath) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'audio_cache', relativePath));
  }

  /// Auto-Play Next Lesson Logic on track finish
  void _handlePlaybackCompleted() {
    playNext();
  }

  Future<void> playNext() async {
    if (_currentPlaylist.isEmpty || _currentLesson == null) return;
    final currentIndex = _currentPlaylist.indexWhere((l) => l.id == _currentLesson!.id);
    if (currentIndex != -1 && currentIndex < _currentPlaylist.length - 1) {
      final nextLesson = _currentPlaylist[currentIndex + 1];
      await playLesson(nextLesson);
    } else {
      await stop();
    }
  }

  Future<void> playPrevious() async {
    if (_currentPlaylist.isEmpty || _currentLesson == null) return;
    final currentIndex = _currentPlaylist.indexWhere((l) => l.id == _currentLesson!.id);
    if (currentIndex > 0) {
      final prevLesson = _currentPlaylist[currentIndex - 1];
      await playLesson(prevLesson);
    }
  }

  /// Persist playback state to SharedPreferences
  Future<void> _savePlaybackState(Duration position) async {
    if (_currentLesson == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_book_id', _currentLesson!.id.split('_').first);
    await prefs.setInt('last_lesson_num', _currentLesson!.lessonNumber);
    await prefs.setInt('last_position_ms', position.inMilliseconds);
  }

  /// Load playback state from SharedPreferences
  Future<Map<String, dynamic>?> getSavedPlaybackState() async {
    final prefs = await SharedPreferences.getInstance();
    final bookId = prefs.getString('last_book_id');
    final lessonNum = prefs.getInt('last_lesson_num');
    final positionMs = prefs.getInt('last_position_ms');

    if (bookId != null && lessonNum != null) {
      return {
        'bookId': bookId,
        'lessonNum': lessonNum,
        'position': Duration(milliseconds: positionMs ?? 0),
      };
    }
    return null;
  }

  Future<void> pause() async => _player.pause();

  Future<void> stop() async {
    await _player.stop();
    _currentLesson = null;
    currentPathNotifier.value = null;
  }

  void dispose() {
    currentPathNotifier.dispose();
    if (_isInitialized) _player.dispose();
  }

  /// Sets the playlist context for auto-play navigation
  void setPlaylist(List<Lesson> playlist) {
    _currentPlaylist = playlist;
  }
}

final audioService = AudioService();