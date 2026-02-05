class Lesson {
  final String id;
  final String title;
  final String titleAr;
  final int lessonNumber;
  final String audioPath;
  final String bookTitle;
  final String bookTitleAr;
  final String duration; // e.g., "45:30" or create a Duration field

  const Lesson({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.bookTitle,
    required this.bookTitleAr,
    required this.lessonNumber,
    required this.audioPath,
    this.duration = '00:00',
  });
}
