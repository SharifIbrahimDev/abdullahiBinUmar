import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../l10n/app_localizations.dart';
import '../models/book.dart';
import '../models/lesson.dart';
import '../data/books_data.dart';
import '../widgets/lesson_tile.dart';
import '../services/audio_service.dart';
import '../widgets/mini_player.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';


class LessonsScreen extends StatelessWidget {
  final Book book;

  const LessonsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final List<Lesson> lessons = getLessonsForBook(book.id);
    final r = Responsive(context);

    // Scale the sliver app bar expanded height
    final expandedHeight = (r.h(320)).clamp(220.0, 400.0);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: expandedHeight,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: EdgeInsets.all(r.s(8)),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: r.s(18)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              title: Text(
                book.title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: r.sp(16),
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
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(r.s(24), 0, r.s(24), r.s(70)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.titleAr,
                          style: GoogleFonts.amiri(
                            color: AppColors.accentGold,
                            fontSize: r.sp(22),
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: r.s(8)),
                        Text(
                          book.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: r.sp(13),
                            height: 1.4,
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
            child: Container(
              padding: EdgeInsets.fromLTRB(r.s(24), r.s(24), r.s(24), r.s(16)),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate('audio_lessons'),
                        style: GoogleFonts.outfit(
                          fontSize: r.sp(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: r.s(4)),
                      Text(
                        AppLocalizations.of(context).translate('playlist_desc'),
                        style: GoogleFonts.inter(
                          fontSize: r.sp(12),
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(8)),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(r.s(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.library_music_rounded, size: r.s(14), color: AppColors.primaryGreen),
                        SizedBox(width: r.s(8)),
                        Text(
                          "${lessons.length} ${AppLocalizations.of(context).translate('parts')}",
                          style: GoogleFonts.inter(
                            fontSize: r.sp(12),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<String?>(
            valueListenable: audioService.currentPathNotifier,
            builder: (context, currentPath, child) {
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: r.s(8)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lesson = lessons[index];
                      final isPlaying = currentPath == lesson.audioPath;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: LessonTile(
                              lesson: lesson,
                              allLessons: lessons,
                              index: index,
                              isPlaying: isPlaying,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: lessons.length,
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: r.s(120))),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}