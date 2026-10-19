# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Flutter references Play Core (deferred components) which this app doesn't use
-dontwarn com.google.android.play.core.**

# Background audio (just_audio / just_audio_background / audio_service)
-keep class com.ryanheise.** { *; }
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# MediaSession / notification compat used by audio_service
-keep class android.support.v4.media.** { *; }
-keep class androidx.media.** { *; }

# App's own MainActivity (method channel)
-keep class com.sharifibrahimdev.abdullahibinumar.** { *; }

# Keep line numbers for readable crash reports
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
