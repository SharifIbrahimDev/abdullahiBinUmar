class Book {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final int lessonCount;
  final String coverPath; // Optional, or use an Icon

  const Book({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.lessonCount,
    this.coverPath = '',
  });
}
