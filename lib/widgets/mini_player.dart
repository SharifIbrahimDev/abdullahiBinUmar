import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../screens/player_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';
import '../l10n/app_localizations.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Consumer<PlayerProvider>(
      builder: (context, provider, child) {
        if (provider.currentLesson == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PlayerScreen(
                  lessons: [provider.currentLesson!],
                  initialIndex: 0,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(position: animation.drive(tween), child: child);
                },
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(r.s(16), 0, r.s(16), r.s(24)),
            height: r.s(76).clamp(65.0, 90.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(r.s(24)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: r.s(12)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(r.s(24)),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: r.s(20),
                        offset: Offset(0, r.s(8)),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'mini_art',
                        child: Container(
                          width: r.s(52).clamp(45.0, 60.0),
                          height: r.s(52).clamp(45.0, 60.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(r.s(16)),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/bin_umar.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: r.s(14)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.currentLesson!.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: r.sp(14),
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: r.s(2)),
                            Text(
                              provider.isPlaying 
                                ? AppLocalizations.of(context).translate('now_playing') 
                                : AppLocalizations.of(context).translate('paused'),
                              style: GoogleFonts.inter(
                                fontSize: r.sp(10),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          provider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.black87,
                          size: r.s(26),
                        ),
                        onPressed: () {
                          provider.isPlaying ? provider.pause() : provider.resume();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next_rounded, color: Colors.black87, size: r.s(26)),
                        onPressed: provider.playNext,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}