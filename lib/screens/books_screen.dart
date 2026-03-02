import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../l10n/app_localizations.dart';

import '../data/books_data.dart';
import '../widgets/mini_player.dart';
import 'lessons_screen.dart';
import '../widgets/app_drawer.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';


class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final query = _searchQuery.toLowerCase();
      return book.title.toLowerCase().contains(query) ||
             book.titleAr.contains(query) ||
             book.description.toLowerCase().contains(query);
    }).toList();

    final r = Responsive(context);

    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: r.h(160).clamp(120.0, 200.0),
            floating: false,
            pinned: true,
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColors.surfaceWhite,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.symmetric(vertical: r.s(16)),
              title: Text(
                AppLocalizations.of(context).translate('app_title'),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: r.sp(20),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGreen.withValues(alpha: 0.05),
                      AppColors.surfaceWhite,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: r.s(12)),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded, size: r.s(26)),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(r.s(24), r.s(8), r.s(24), r.s(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('greeting'),
                    style: GoogleFonts.inter(
                      fontSize: r.sp(13),
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(height: r.s(4)),
                  Text(
                    AppLocalizations.of(context).translate('bismillah'),
                    style: GoogleFonts.amiri(
                      fontSize: r.sp(20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: r.s(20)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = filteredBooks[index];
                  // Book cover height scales with screen
                  final coverWidth = r.s(80).clamp(70.0, 100.0);
                  final coverHeight = r.s(115).clamp(100.0, 140.0);

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.only(bottom: r.s(18)),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonsScreen(book: book),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(r.s(14)),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: 'book_${book.id}',
                                      child: Container(
                                        width: coverWidth,
                                        height: coverHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(r.s(16)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.1),
                                              blurRadius: r.s(15),
                                              offset: Offset(r.s(4), r.s(8)),
                                            ),
                                          ],
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/bin_umar.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: r.s(18)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.title,
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontSize: r.sp(16),
                                              color: Colors.black87,
                                              height: 1.2,
                                            ),
                                          ),
                                          SizedBox(height: r.s(6)),
                                          Text(
                                            book.titleAr,
                                            textDirection: TextDirection.rtl,
                                            style: GoogleFonts.amiri(
                                              fontWeight: FontWeight.bold,
                                              fontSize: r.sp(16),
                                              color: AppColors.accentGold,
                                            ),
                                          ),
                                          SizedBox(height: r.s(14)),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen.withValues(alpha: 0.08),
                                              borderRadius: BorderRadius.circular(r.s(12)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.playlist_play_rounded, size: r.s(15), color: AppColors.primaryGreen),
                                                SizedBox(width: r.s(6)),
                                                Text(
                                                  "${book.lessonCount} ${AppLocalizations.of(context).translate('lessons')}",
                                                  style: GoogleFonts.inter(
                                                    color: AppColors.primaryGreen,
                                                    fontSize: r.sp(11),
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios_rounded, size: r.s(14), color: Colors.grey.withValues(alpha: 0.3)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredBooks.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: r.s(120))),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
