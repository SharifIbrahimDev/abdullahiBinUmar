import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/books_screen.dart';
import 'screens/about_screen.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';


import 'screens/splash_screen.dart';

import 'services/audio_service.dart';
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
        child: const MyApp(),
      ),
      );
  }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen for global audio messages (Errors/Offline status)
    audioService.messageStream.listen((message) {
      // Use a global key or just rely on the active context if possible, 
      // but simpler to use scaffoldMessengerKey for global access.
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Premium Color Palette
    const primaryGreen = Color(0xFF1B5E20); // Royal Green
    const accentGold = Color(0xFFC5A059);  // Deep Gold
    const surfaceWhite = Color(0xFFFAF9F6); // Ivory/Off-white

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sheikh Abdullahi Bin Umar',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: surfaceWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: accentGold,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        // Modern Typography
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
          bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          color: Colors.white,
        ),
      ),
      scaffoldMessengerKey: rootScaffoldMessengerKey, // 👈 KEY ADDITION
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const BooksScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
