import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Bin Umar Library',
      'greeting': 'Assalamu Alaikum',
      'bismillah': 'Bismillahir Rahmanir Rahim',
      'audio_books': 'Audio Books',
      'about_sheikh': 'About the Sheikh',
      'about_developer': 'About the Developer',
      'about_app': 'About the App',
      'share_app': 'Share App',
      'rate_app': 'Rate App',
      'lessons': 'Lessons',
      'parts': 'Parts',
      'audio_lessons': 'Audio Lessons',
      'playlist_desc': 'Curated playlist for this book',
      'now_playing': 'Now Playing',
      'paused': 'Paused',
      'search': 'Search...',
      'version': 'Version',
      'islamic_audio_library': 'Islamic Audio Library',
      'try_again': 'Try Again',
      'oops': 'Oops!',
      'language': 'Language',
      'english': 'English',
      'hausa': 'Hausa',
      'arabic': 'Arabic',
      'system_default': 'System Default',
      'features': 'App Features',
      'digital_lib_desc': 'Access a comprehensive collection of Islamic audio lessons by Sheikh Abdullahi Bin Umar, organized for easy learning.',
      'offline_access': 'Offline Access',
      'offline_access_desc': 'Automatically caches played lessons so you can listen to them later even without an internet connection.',
      'smart_player': 'Smart Player',
      'smart_player_desc': 'Saves your playback position and automatically continues from where you left off.',
      'spread_knowledge': 'Spread the Knowledge',
      'charity_project': 'This application is a charity project aimed at making Islamic knowledge accessible to everyone. May Allah reward all those who contributed to its development and use.',
      'share_option': 'Share Option',
      'share_link': 'Share Link',
      'share_apk': 'Share APK File (Offline)',
      'sheikh_role': 'Religious Scholar & Preacher',
      'sheikh_bio_title': 'Biography',
      'sheikh_bio_content': 'Sheikh Abdullahi Bin Umar is a renowned Islamic scholar dedicated to teaching the Quran and Hadith. His comprehensive explanations of classical texts—including Sahihul Bukhari, Ash-Shatibiyyah, Alfiyyatus Siyudi, Muntaqa Ibnil Jarud, and Ilalut Tirmizi—have benefited thousands of students across the globe.',
      'contact_sheikh': 'Contact Sheikh',
    },
    'ha': {
      'app_title': 'Dakin Karatun Bin Umar',
      'greeting': 'Assalamu Alaikum',
      'bismillah': 'Bismillahir Rahmanir Rahim',
      'audio_books': 'Littattafan Audio',
      'about_sheikh': 'Game da Sheikh',
      'about_developer': 'Game da Mai Haɓaka',
      'about_app': 'Game da Manhajoji',
      'share_app': 'Raba Manhajoji',
      'rate_app': 'Auna Manhajoji',
      'lessons': 'Darussa',
      'parts': 'Sassa',
      'audio_lessons': 'Darussan Audio',
      'playlist_desc': 'Jerin darussan wannan littafi',
      'now_playing': 'Ana Kunna',
      'paused': 'An Tsayar da',
      'search': 'Bincika...',
      'version': 'Siffa',
      'islamic_audio_library': 'Taskar Audio ta Musulunci',
      'try_again': 'Sake Jarabawa',
      'oops': 'Subhanallah!',
      'language': 'Yare',
      'english': 'Turanci',
      'hausa': 'Hausa',
      'arabic': 'Larabci',
      'system_default': 'Tsohuwar Siffar Wayarka',
      'features': 'Sassan Manhajar',
      'digital_lib_desc': 'Samun damar yin amfani da cikakkun darussan audio na Musulunci daga Sheikh Abdullahi Bin Umar, waɗanda aka tsara don sauƙin koyo.',
      'offline_access': 'Sauraro Ba Tare Da Hali Ba',
      'offline_access_desc': 'Yana adana darussan da aka saurara kai tsaye ta yadda zaka iya saurara daga baya koda babu intanet.',
      'smart_player': 'Na\'urar Kunna Darussa ta Musamman',
      'smart_player_desc': 'Hana asarar inda ka tsaya sauraro da zarar ka sake budewa.',
      'spread_knowledge': 'Yaɗa Ilimi',
      'charity_project': 'Wannan manhaja aiki ne na sadakar jariyya da nufin sanya ilimin Musulunci ya isa ga kowa. Allah ya saka wa duk waɗanda suka ba da gudunmawa wajen haɓakawa da kuma yin amfani da ita.',
      'share_option': 'Zaɓukan Raba Manhajar',
      'share_link': 'Raba Mahaɗin Intanet',
      'share_apk': 'Raba Fayil ɗin APK',
      'sheikh_role': 'Malamin Addini & Mai Wa\'azi',
      'sheikh_bio_title': 'Tarihin Sheikh',
      'sheikh_bio_content': 'Sheikh Abdullahi Bin Umar babban malamin addinin Musulunci ne wanda ya sadaukar da kansa wajen koyar da Alkur\'ani da Hadisi. Sharhin sa akan manyan litattafai—kamarsu Sahihul Bukhari, Ash-Shatibiyyah, Alfiyyatus Siyudi, Muntaqa Ibnil Jarud, da kuma Ilalut Tirmizi—sun amfani dubun-dubatar ɗalibai.',
      'contact_sheikh': 'Tuntuɓi Sheikh',
    },
    'ar': {
      'app_title': 'مكتبة بن عمر',
      'greeting': 'السلام عليكم',
      'bismillah': 'بسم الله الرحمن الرحيم',
      'audio_books': 'كتب صوتية',
      'about_sheikh': 'عن الشيخ',
      'about_developer': 'عن المطور',
      'about_app': 'عن التطبيق',
      'share_app': 'مشاركة التطبيق',
      'rate_app': 'تقييم التطبيق',
      'lessons': 'دروس',
      'parts': 'أجزاء',
      'audio_lessons': 'دروس صوتية',
      'playlist_desc': 'قائمة تشغيل منسقة لهذا الكتاب',
      'now_playing': 'يعمل الآن',
      'paused': 'متوقف مؤقتاً',
      'search': 'بحث...',
      'version': 'الإصدار',
      'islamic_audio_library': 'المكتبة الصوتية الإسلامية',
      'try_again': 'حاول مرة أخرى',
      'oops': 'عفواً!',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'hausa': 'الهوسا',
      'arabic': 'العربية',
      'system_default': 'افتراضي النظام',
      'features': 'مميزات التطبيق',
      'digital_lib_desc': 'الوصول إلى مجموعة شاملة من الدروس الصوتية الإسلامية للشيخ عبد الله بن عمر، مرتبة ليسهل تعلمها.',
      'offline_access': 'استماع بدون إنترنت',
      'offline_access_desc': 'يحفظ الدروس المستمع إليها تلقائياً لكي تستطيع الاستماع إليها لاحقاً حتى بدون اتصال بالإنترنت.',
      'smart_player': 'مشغل ذكي',
      'smart_player_desc': 'يحفظ موضع الاستماع الخاص بك ويستمر تلقائياً من حيث توقفت.',
      'spread_knowledge': 'انشر العلم',
      'charity_project': 'هذا التطبيق هو مشروع خيري يهدف إلى جعل العلم الإسلامي متاحاً للجميع. جزى الله خيراً كل من ساهم في تطويره واستخدامه.',
      'share_option': 'خيارات المشاركة',
      'share_link': 'مشاركة الرابط',
      'share_apk': 'مشاركة ملف APK',
      'sheikh_role': 'عالم دين وداعية',
      'sheikh_bio_title': 'سيرة الشيخ',
      'sheikh_bio_content': 'الشيخ عبد الله بن عمر عالم إسلامي معروف كرس حياته لتدريس القرآن والحديث. وقد استفاد آلاف الطلاب من شروحاته الشاملة للنصوص الكلاسيكية، بما في ذلك صحيح البخاري، والشاطبية، وألفية السيوطي، ومنتقى ابن الجارود، وعلل الترمذي.',
      'contact_sheikh': 'اتصل بالشيخ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ha', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
