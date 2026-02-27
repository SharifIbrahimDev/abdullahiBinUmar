import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/books_screen.dart';
import 'screens/about_screen.dart';
import 'screens/developer_screen.dart';
import 'screens/app_info_screen.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';


import 'screens/splash_screen.dart';

import 'widgets/app_snackbar.dart';
import 'services/error_handler.dart';
import 'services/audio_service.dart';
import 'constants/app_colors.dart';


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
      final friendlyMessage = ErrorHandler.mapErrorMessage(message);
      AppSnackbar.showGlobalError(rootScaffoldMessengerKey, friendlyMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sheikh Abdullahi Bin Umar',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.surfaceWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentGold,
          surface: Colors.white,
          onSurface: Colors.black87,
          secondaryContainer: AppColors.accentGold.withValues(alpha: 0.1),
        ),
        // Premium Typography Hierarchy
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displaySmall: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
          bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black87, height: 1.5),
          bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.08)),
          ),
          color: Colors.white,
        ),
        // Modern Button Styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const BooksScreen(),
        '/about': (context) => const AboutScreen(),
        '/developer': (context) => const DeveloperScreen(),
        '/app_info': (context) => const AppInfoScreen(),
      },
    );
  }
}
