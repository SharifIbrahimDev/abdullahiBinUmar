import 'package:abdullahi_bin_umar/models/book.dart';
import 'package:abdullahi_bin_umar/models/lesson.dart';

// Scaleable Book List
final List<Book> books = [
  const Book(
    id: 'Elalut-tirmizy',
    title: 'Ilalut Tirmizi',
    titleAr: 'علل الترمذي',
    description: 'Explanation of the defects in Hadith by Tirmidhi',
    descriptionAr: 'شرح كتاب علل الترمذي',
    lessonCount: 11,
  ),
  const Book(
    id: "Arba'una fil Ahkam",
    title: "Arba'una fil Ahkam",
    titleAr: 'الأربعون في الأحكام',
    description: 'Explanation of the 40 Hadiths on Rulings',
    descriptionAr: 'شرح الأحاديث الأربعين في الأحكام',
    lessonCount: 22,
  ),
  const Book(
    id: 'Alfara\'idul jalilah',
    title: 'Sharhul Fara\'idul Jalilah', 
    titleAr: 'شرح الفوائد الجليلة',
    description: 'Explanation of The Exquisite Pearls',
    descriptionAr: 'شرح الفوائد الجليلة',
    lessonCount: 42,
  ),
  const Book(
    id: 'Shu\'ubah',
    title: 'Riwayatu Shu\'bah',
    titleAr: 'رواية شعبة عن عاصم',
    description: 'Principles of the Shu\'bah Recitation',
    descriptionAr: 'شرح أصول رواية شعبة عن عاصم',
    lessonCount: 21,
  ),
  const Book(
    id: 'Risalatu Abi Dawud',
    title: 'Risalatu Abi Dawud',
    titleAr: 'رسالة أبي داود',
    description: 'Commentary on Abu Dawud\'s Message',
    descriptionAr: 'شرح رسالة الإمام أبي داود في وصف سننه',
    lessonCount: 5,
  ),
  const Book(
    id: 'Sulalatul-miftah',
    title: 'Sulalatul Miftah',
    titleAr: 'سلالة المفتاح',
    description: 'Commentary on Sulalat al-Miftah',
    descriptionAr: 'شرح منظومة سلالة المفتاح في أصول التفسير',
    lessonCount: 32,
  ),
  const Book(
    id: 'Al-ibanah an ma\'aanilqira\'aat',
    title: 'Al-Ibanah \'an Ma\'anil Qira\'at',
    titleAr: 'الإبانة عن معاني القراءات',
    description: 'The Clarification of the Meanings of Recitations',
    descriptionAr: 'الإبانة عن معاني القراءات',
    lessonCount: 4,
  ),
  const Book(
    id: 'Alfiyyatus-siyudi',
    title: 'Alfiyyatus Siyudi',
    titleAr: 'ألفية السيوطي',
    description: 'The Thousand-line Poem by Al-Siyuti',
    descriptionAr: 'ألفية السيوطي في علم الحديث',
    lessonCount: 30,
  ),
  const Book(
    id: 'Jazariyyah',
    title: 'Al-Jazariyyah',
    titleAr: 'الجزرية',
    description: 'Principles of Tajweed by Ibn Al-Jazari',
    descriptionAr: 'المقدمة الجزرية في التجويد',
    lessonCount: 5,
  ),
  const Book(
    id: 'Maraqis-su\'ud(0)',
    title: 'Maraqis Su\'ud',
    titleAr: 'مراقي السعود',
    description: 'Ascent of Success in Usul al-Fiqh',
    descriptionAr: 'شرح مراقي السعود',
    lessonCount: 19,
  ),
  const Book(
    id: 'Muntaqaa-ibniljarud',
    title: 'Muntaqa Ibnil Jarud',
    titleAr: 'منتقى ابن الجارود',
    description: 'Selected Hadiths by Ibn al-Jarud',
    descriptionAr: 'شرح منتقى ابن الجارود',
    lessonCount: 58,
  ),
  const Book(
    id: 'Sahihul Bukhari_Kitabu Khabaril Aahaad',
    title: 'Sahihul Bukhari (Khabarul Aahaad)',
    titleAr: 'صحيح البخاري - خبر الواحد',
    description: 'Chapter on Solitary Narrations in Sahih Bukhari',
    descriptionAr: 'صحيح البخاري كتاب أخبار الآحاد',
    lessonCount: 2,
  ),
  const Book(
    id: 'Shadibiyyah',
    title: 'Ash-Shatibiyyah',
    titleAr: 'الشاطبية',
    description: 'Mastery of the Seven Recitations',
    descriptionAr: 'شرح حرز الأماني ووجه التهاني',
    lessonCount: 96,
  ),
  const Book(
    id: 'Tazkiratus-sami\'i',
    title: 'Tazkiratus Sami\'i',
    titleAr: 'تذكرة السامي',
    description: 'Reminder for the Listener and Speaker',
    descriptionAr: 'تذكرة السامي والمتكلم',
    lessonCount: 7,
  ),
  const Book(
    id: 'Tuhfah',
    title: 'Tuhfatul Atfal',
    titleAr: 'تحفة الأطفال',
    description: 'The Gift for Children in Tajweed',
    descriptionAr: 'تحفة الأطفال في تجويد القرآن',
    lessonCount: 10,
  ),
  const Book(
    id: 'Sulalatul miftah',
    title: 'Sulalatul Miftah (Short)',
    titleAr: 'سلالة المفتاح',
    description: 'A shorter commentary on Sulalat al-Miftah',
    descriptionAr: 'شرح منظومة سلالة المفتاح',
    lessonCount: 3,
  ),
];

/// Generates lessons for a given book using a dynamic path structure.
/// Path format: bookId/lessonNumber.mp3
List<Lesson> getLessonsForBook(String bookId) {
  final book = books.firstWhere(
    (b) => b.id == bookId,
    orElse: () => books.first, // Fallback to avoid crash
  );
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