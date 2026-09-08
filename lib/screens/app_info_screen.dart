import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryGreen, size: r.s(20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).translate('about_app'),
          style: GoogleFonts.outfit(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: r.sp(18),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(r.s(24)),
        child: Column(
          children: [
            // App Icon / Logo
            Center(
              child: Container(
                width: r.s(120),
                height: r.s(120),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(r.s(30)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      blurRadius: r.s(20),
                      offset: Offset(0, r.s(10)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: r.s(60),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: r.s(32)),
            Text(
              AppLocalizations.of(context).translate('app_title'),
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: r.sp(22),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(8)),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final ver = snapshot.hasData ? snapshot.data!.version : "1.1.0";
                return Text(
                  "${AppLocalizations.of(context).translate('version')} $ver",
                  style: GoogleFonts.inter(
                    fontSize: r.sp(14),
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            SizedBox(height: r.s(32)),

            // Language Switcher Section
            _buildSectionTitle(context, r, AppLocalizations.of(context).translate('language')),
            SizedBox(height: r.s(16)),
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: r.s(12),
                  crossAxisSpacing: r.s(12),
                  childAspectRatio: 1.5,
                  children: [
                    _buildLanguageCard(context, r, 
                      title: AppLocalizations.of(context).translate('system_default'), 
                      subtitle: "Auto",
                      locale: null, 
                      currentLocale: localeProvider.locale,
                      onTap: () => localeProvider.clearLocale(),
                      icon: Icons.brightness_auto_rounded,
                    ),
                    _buildLanguageCard(context, r, 
                      title: AppLocalizations.of(context).translate('english'), 
                      subtitle: "English",
                      locale: const Locale('en'), 
                      currentLocale: localeProvider.locale,
                      onTap: () => localeProvider.setLocale(const Locale('en')),
                      initials: "EN",
                    ),
                    _buildLanguageCard(context, r, 
                      title: AppLocalizations.of(context).translate('hausa'), 
                      subtitle: "Hausa",
                      locale: const Locale('ha'), 
                      currentLocale: localeProvider.locale,
                      onTap: () => localeProvider.setLocale(const Locale('ha')),
                      initials: "HA",
                    ),
                    _buildLanguageCard(context, r, 
                      title: AppLocalizations.of(context).translate('arabic'), 
                      subtitle: "العربية",
                      locale: const Locale('ar'), 
                      currentLocale: localeProvider.locale,
                      onTap: () => localeProvider.setLocale(const Locale('ar')),
                      initials: "AR",
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: r.s(32)),

            // Features Section
            _buildSectionTitle(context, r, AppLocalizations.of(context).translate('features')),
            SizedBox(height: r.s(16)),
            _buildFeatureCard(context, r,
              title: AppLocalizations.of(context).translate('audio_books'),
              description: AppLocalizations.of(context).translate('digital_lib_desc'),
              icon: Icons.library_books_rounded,
            ),
            SizedBox(height: r.s(16)),
            _buildFeatureCard(context, r,
              title: AppLocalizations.of(context).translate('offline_access'),
              description: AppLocalizations.of(context).translate('offline_access_desc'),
              icon: Icons.offline_pin_rounded,
            ),
            SizedBox(height: r.s(16)),
            _buildFeatureCard(context, r,
              title: AppLocalizations.of(context).translate('smart_player'),
              description: AppLocalizations.of(context).translate('smart_player_desc'),
              icon: Icons.auto_stories_rounded,
            ),
            SizedBox(height: r.s(40)),

            _buildSectionTitle(context, r, AppLocalizations.of(context).translate('spread_knowledge')),
            SizedBox(height: r.s(16)),
            Text(
              AppLocalizations.of(context).translate('charity_project'),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: r.sp(15),
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            SizedBox(height: r.s(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, Responsive r, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: r.s(8)),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: r.sp(18),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, Responsive r, {
    required String title, 
    required String subtitle,
    required Locale? locale, 
    required Locale? currentLocale,
    required VoidCallback onTap,
    String? initials,
    IconData? icon,
  }) {
    final isSelected = locale?.languageCode == currentLocale?.languageCode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(r.s(20)),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.black.withOpacity(0.05),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.2),
              blurRadius: r.s(8),
              offset: Offset(0, r.s(4)),
            ),
          ] : null,
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: r.s(8),
                right: r.s(8),
                child: Icon(Icons.check_circle_rounded, color: Colors.white, size: r.s(16)),
              ),
            Padding(
              padding: EdgeInsets.all(r.s(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: r.s(32),
                    height: r.s(32),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.primaryGreen.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: icon != null 
                        ? Icon(icon, color: isSelected ? Colors.white : AppColors.primaryGreen, size: r.s(18))
                        : Text(
                            initials ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: r.sp(12),
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.primaryGreen,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: r.s(8)),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: r.sp(14),
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: r.sp(11),
                      color: isSelected ? Colors.white70 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Responsive r, {required String title, required String description, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(r.s(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(24)),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: r.s(10),
            offset: Offset(0, r.s(4)),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(r.s(12)),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.06),
              borderRadius: BorderRadius.circular(r.s(16)),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: r.s(24)),
          ),
          SizedBox(width: r.s(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: r.sp(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: r.sp(14),
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
