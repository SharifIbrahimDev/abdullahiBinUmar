import 'package:abdullahi_bin_umar/models/book.dart';
import 'package:abdullahi_bin_umar/models/lesson.dart';

// Scaleable Book List
final List<Book> books = [
  const Book(
    id: 'sharhu_ilalit_tirmizi',
    title: 'Sharhu Ilalit Tirmizi',
    titleAr: 'شرح علل الترمذي',
    description: 'Explanation of the defects in Hadith by Tirmidhi',
    descriptionAr: 'شرح كتاب علل الترمذي',
    lessonCount: 11,
  ),
  const Book(
    id: 'sharhul_arbaina_fil_ahkam',
    title: 'Sharhul Arba\'ina fil Ahkam',
    titleAr: 'شرح الأربعين في الأحكام',
    description: 'Explanation of the 40 Hadiths on Rulings',
    descriptionAr: 'شرح الأحاديث الأربعين في الأحكام',
    lessonCount: 6,
  ),
  const Book(
    id: 'sharhul_faraidul_jalilah',
    title: 'Sharhul Fara\'idul Jalilah', // Keep title readable
    titleAr: 'شرح الفوائد الجليلة',
    description: 'Explanation of The Exquisite Pearls',
    descriptionAr: 'شرح الفوائد الجليلة',
    lessonCount: 27,
  ),
  const Book(
    id: 'usulu_riwayati_shubah',
    title: 'Usulu Riwayati Shu\'bah',
    titleAr: 'أصول رواية شعبة',
    description: 'Principles of the Shu\'bah Recitation',
    descriptionAr: 'شرح أصول رواية شعبة عن عاصم',
    lessonCount: 20,
  ),
  const Book(
    id: 'sharhu_risalati_abi_dawud',
    title: 'Sharhu Risalati Abi Dawud',
    titleAr: 'شرح رسالة أبي داود',
    description: 'Commentary on Abu Dawud\'s Message',
    descriptionAr: 'شرح رسالة الإمام أبي داود في وصف سننه',
    lessonCount: 5,
  ),
  const Book(
    id: 'sharhu_sulalatil_miftah',
    title: 'Sharhu Sulalatil Miftah',
    titleAr: 'شرح سلالة المفتاح',
    description: 'Commentary on Sulalat al-Miftah',
    descriptionAr: 'شرح منظومة سلالة المفتاح في أصول التفسير',
    lessonCount: 15,
  ),
];

/// Generates lessons for a given book using a dynamic path structure.
/// Path format: bookId/lessonNumber.mp3
List<Lesson> getLessonsForBook(String bookId) {
  final book = books.firstWhere((b) => b.id == bookId);
  final int count = book.lessonCount;
  const int startOffset = 1;

  return List.generate(
    count,
    (index) {
      final int lessonNum = index + startOffset;
      // Relative path only - AudioService will prepend Base URL or Assets path
      final String relativePath = '$bookId/$lessonNum.mp3';

      const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      String toArabic(int number) {
        return number.toString().split('').map((digit) {
          final int val = int.parse(digit);
          return arabicNumerals[val];
        }).join('');
      }

      String getMockDuration(int lessonNumber) {
        // Just mock some varying durations
        final mins = 10 + (lessonNumber % 20);
        final secs = (lessonNumber * 7) % 60;
        return '$mins:${secs.toString().padLeft(2, '0')}';
      }

      return Lesson(
        id: '${bookId}_$lessonNum',
        title: 'Lesson $lessonNum',
        titleAr: 'الدرس ${toArabic(lessonNum)}',
        bookTitle: book.title,
        bookTitleAr: book.titleAr,
        lessonNumber: lessonNum,
        audioPath: relativePath, // Now just bookId/lessonNum.mp3
        duration: getMockDuration(lessonNum),
      );
    },
  );
}