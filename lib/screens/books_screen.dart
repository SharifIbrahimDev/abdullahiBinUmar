import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/books_data.dart';
import '../widgets/mini_player.dart';
import 'lessons_screen.dart';
import '../widgets/app_drawer.dart';
import '../constants/app_colors.dart';


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

    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColors.surfaceWhite,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(vertical: 16),
              title: Text(
                "Bin Umar Library",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontSize: 22,
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
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search_rounded, size: 28),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assalamu Alaikum",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                   "Bismillahir Rahmanir Rahim",
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = filteredBooks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Hero(
                                tag: 'book_${book.id}',
                                child: Container(
                                  width: 85,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 15,
                                        offset: const Offset(4, 8),
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/bin_umar.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      book.titleAr,
                                      textDirection: TextDirection.rtl,
                                      style: GoogleFonts.amiri(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: AppColors.accentGold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGreen.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.playlist_play_rounded, size: 16, color: AppColors.primaryGreen),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${book.lessonCount} Lessons",
                                            style: GoogleFonts.inter(
                                              color: AppColors.primaryGreen,
                                              fontSize: 11,
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
                              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.withValues(alpha: 0.3)),
                            ],
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
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
