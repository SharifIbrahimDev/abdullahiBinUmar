import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abdullahi_bin_umar/data/books_data.dart';
import 'package:abdullahi_bin_umar/l10n/app_localizations.dart';

void main() {
  group('Books and Lessons Data Tests', () {
    test('Books list is not empty and has valid metadata', () {
      expect(books.isNotEmpty, isTrue);
      for (final book in books) {
        expect(book.id.isNotEmpty, isTrue);
        expect(book.title.isNotEmpty, isTrue);
        expect(book.titleAr.isNotEmpty, isTrue);
        expect(book.lessonCount, greaterThan(0));
      }
    });

    test('getLessonsForBook returns correct lesson count and format', () {
      final firstBook = books.first;
      final lessons = getLessonsForBook(firstBook.id);

      expect(lessons.length, equals(firstBook.lessonCount));
      expect(lessons.first.lessonNumber, equals(1));
      expect(lessons.first.audioPath, equals('${firstBook.id}/1.mp3'));
      expect(lessons.last.lessonNumber, equals(firstBook.lessonCount));
    });
  });

  group('Localization Tests', () {
    test('English translations are non-empty for standard keys', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.translate('app_title'), equals('Bin Umar Library'));
      expect(l10n.translate('about_sheikh'), equals('About the Sheikh'));
      expect(l10n.translate('rate_app'), equals('Rate App'));
    });

    test('Hausa translations are present', () {
      final l10n = AppLocalizations(const Locale('ha'));
      expect(l10n.translate('app_title'), equals('Dakin Karatun Bin Umar'));
      expect(l10n.translate('about_sheikh'), equals('Game da Sheikh'));
    });

    test('Arabic translations are present', () {
      final l10n = AppLocalizations(const Locale('ar'));
      expect(l10n.translate('app_title'), equals('مكتبة بن عمر'));
      expect(l10n.translate('about_sheikh'), equals('عن الشيخ'));
    });
  });
}
