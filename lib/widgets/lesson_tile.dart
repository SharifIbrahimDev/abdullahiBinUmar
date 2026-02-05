import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../screens/player_screen.dart';
import '../providers/player_provider.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  final List<Lesson> allLessons;       // ← NEW: Full list of lessons in the book
  final int index;                     // ← NEW: This lesson's position in the list
  final bool isPlaying;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.allLessons,
    required this.index,
    this.isPlaying = false,
  });

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return '--:--';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, provider, child) {
        final currentDuration = provider.getLessonDuration(lesson);
        final isActive = isPlaying || (provider.currentLesson?.id == lesson.id);
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isActive ? Border.all(color: const Color(0xFF1B5E20), width: 1.5) : null,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      lessons: allLessons,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Lesson Number with better styling
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF1B5E20) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${lesson.lessonNumber}',
                          style: GoogleFonts.outfit(
                            color: isActive ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lesson.titleAr,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isActive ? const Color(0xFFC5A059) : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(currentDuration),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Icon
                    Icon(
                      isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: const Color(0xFF1B5E20),
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
