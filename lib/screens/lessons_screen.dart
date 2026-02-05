import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../models/lesson.dart';
import '../data/books_data.dart';
import '../widgets/lesson_tile.dart';
import '../services/audio_service.dart';
import '../widgets/mini_player.dart'; // Import to access notifier

class LessonsScreen extends StatelessWidget {
  final Book book;

  const LessonsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final List<Lesson> lessons = getLessonsForBook(book.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                book.title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Hero(
                    tag: 'book_${book.id}',
                    child: Image.asset(
                      'assets/images/bin_umar.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.titleAr,
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFC5A059),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Text(
                    "Available Lessons",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${lessons.length} Parts",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: audioService.currentPathNotifier,
            builder: (context, currentPath, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lesson = lessons[index];
                    final isPlaying = currentPath == lesson.audioPath;

                    return LessonTile(
                      lesson: lesson,
                      allLessons: lessons,
                      index: index,
                      isPlaying: isPlaying,
                    );
                  },
                  childCount: lessons.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}