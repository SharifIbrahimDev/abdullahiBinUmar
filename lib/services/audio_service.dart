import 'package:universal_io/io.dart'; // 👈 Use universal_io for File/Platform web compat
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lesson.dart';

// ... (baseAudioUrl)
const String baseAudioUrl = 'https://raw.githubusercontent.com/SharifIbrahimDev/abdullahiBinUmar/main/';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final Dio _dio = Dio();
  
  Lesson? _currentLesson;
  List<Lesson> _currentPlaylist = [];
  
  // Notifier for global "now playing" state
  final ValueNotifier<String?> currentPathNotifier = ValueNotifier<String?>(null);

  // 🆕 Stream for errors and messages (to show SnackBar in UI)
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  AudioPlayer get player => _player;
  Lesson? get currentLesson => _currentLesson;

  AudioService() {
    _initListeners();
  }

  void _initListeners() {
    // Listen for playback completion to trigger 3️⃣ Auto-Play Next
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handlePlaybackCompleted();
      }
    });

    // 4️⃣ Resume From Last Position - Save position periodically
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

      if (baseAudioUrl.isEmpty) {
        // ... (asset logic)
        effectivePath = 'assets/audio/${lesson.audioPath}';
        if (kIsWeb && effectivePath.startsWith('assets/')) {
          effectivePath = effectivePath.replaceFirst('assets/', '');
        }
        await _player.setAudioSource(AudioSource.asset(effectivePath));
      } else {
        final remoteUrl = '$baseAudioUrl${lesson.audioPath}';
        
        debugPrint('🔍 Requested URL: $remoteUrl'); // Debug #1

        if (kIsWeb) {
          // 🌐 Web: Direct Stream (No Caching, No DNS check)
          debugPrint('🌐 Web Mode: Streaming directly...');
          await _player.setAudioSource(AudioSource.uri(Uri.parse(remoteUrl)));
        } else {
          // 📱 Mobile: Cached Streaming + Offline Check
          final localFile = await _getCacheFile(lesson.audioPath);

          if (await localFile.exists()) {
            debugPrint('📂 Paying from Cache: ${localFile.path}');
            await _player.setAudioSource(AudioSource.file(localFile.path));
          } else {
            try {
               final result = await InternetAddress.lookup('google.com');
               if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                 debugPrint('📡 Online: Streaming & Downloading...');
                 await _player.setAudioSource(AudioSource.uri(Uri.parse(remoteUrl)));
                 _downloadToCache(remoteUrl, localFile);
               }
            } on SocketException catch (e) {
               debugPrint('❌ Offline Error: $e');
               _messageController.add("No Internet Connection. Please connect to WiFi or Mobile Data.");
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

  // ... (rest of methods)

  /// 2️⃣ Download file to local cache
  Future<void> _downloadToCache(String url, File file) async {
    try {
      // Create directory if missing
      await file.parent.create(recursive: true);
      await _dio.download(url, file.path);
      debugPrint('Downloaded to cache: ${file.path}');
    } catch (e) {
      debugPrint('Download failed: $e');
    }
  }

  /// Get reference to cache file location
  Future<File> _getCacheFile(String relativePath) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'audio_cache', relativePath));
  }

  /// 3️⃣ Auto-Play Next Lesson Logic
  void _handlePlaybackCompleted() {
    if (_currentPlaylist.isEmpty || _currentLesson == null) return;

    final currentIndex = _currentPlaylist.indexWhere((l) => l.id == _currentLesson!.id);
    if (currentIndex != -1 && currentIndex < _currentPlaylist.length - 1) {
      final nextLesson = _currentPlaylist[currentIndex + 1];
      playLesson(nextLesson);
    } else {
      stop(); // End of book
    }
  }

  /// 4️⃣ Persist playback state to SharedPreferences
  Future<void> _savePlaybackState(Duration position) async {
    if (_currentLesson == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_book_id', _currentLesson!.id.split('_').first);
    await prefs.setInt('last_lesson_num', _currentLesson!.lessonNumber);
    await prefs.setInt('last_position_ms', position.inMilliseconds);
  }

  /// 4️⃣ Load playback state from SharedPreferences
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
    _player.dispose();
  }
  /// Sets the playlist context for auto-play navigation
  void setPlaylist(List<Lesson> playlist) {
    _currentPlaylist = playlist;
  }
}

final audioService = AudioService();