import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';
import '../l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const platform = MethodChannel('com.example.app/share');

  Future<void> _shareApp(BuildContext context) async {
    final r = Responsive(context);
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(r.s(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(r.s(32))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.s(40),
              height: r.s(4),
              margin: EdgeInsets.only(bottom: r.s(24)),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              l10n.translate('share_option'),
              style: GoogleFonts.outfit(
                fontSize: r.sp(18),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(24)),
            _buildShareOption(
              context, r,
              icon: Icons.link_rounded,
              title: l10n.translate('share_link'),
              onTap: () {
                Navigator.pop(context);
                Share.shareUri(Uri.parse('https://sharifibrahimdev.github.io'));
              },
            ),
            SizedBox(height: r.s(12)),
            _buildShareOption(
              context, r,
              icon: Icons.install_mobile_rounded,
              title: l10n.translate('share_apk'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  if (Platform.isAndroid) {
                    final String? apkPath = await platform.invokeMethod('getApkPath');
                    if (apkPath != null) {
                      await Share.shareUri(Uri.file(apkPath));
                    }
                  }
                } catch (e) {
                  debugPrint('APK Sharing failed: $e');
                }
              },
            ),
            SizedBox(height: r.s(16)),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(BuildContext context, Responsive r, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(r.s(10)),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(r.s(12)),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: r.s(22)),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: r.sp(15),
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: r.s(14), color: Colors.black26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.s(16)),
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Drawer(
      width: r.screenWidth * 0.85,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // Glassmorphism background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Column(
            children: [
              // Premium Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(r.s(24), r.s(60), r.s(24), r.s(32)),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(r.s(60))),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                      blurRadius: r.s(20),
                      offset: Offset(0, r.s(10)),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(r.s(3)),
                      decoration: const BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: r.s(38).clamp(32.0, 48.0),
                        backgroundImage: const AssetImage('assets/images/bin_umar.jpg'),
                        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                      ),
                    ),
                    SizedBox(height: r.s(20)),
                    Text(
                      "Sheikh Abdullahi\nBin Umar",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: r.sp(22),
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: r.s(8)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(4)),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(r.s(8)),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('islamic_audio_library'),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: r.sp(11),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: r.s(16)),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: r.s(16)),
                  children: [
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.grid_view_rounded,
                      title: AppLocalizations.of(context).translate('audio_books'),
                      onTap: () => Navigator.pop(context),
                      isActive: true,
                    ),
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.person_outline_rounded,
                      title: AppLocalizations.of(context).translate('about_sheikh'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.developer_mode_rounded,
                      title: AppLocalizations.of(context).translate('about_developer'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/developer');
                      },
                    ),
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.info_outline_rounded,
                      title: AppLocalizations.of(context).translate('about_app'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/app_info');
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.s(20), vertical: r.s(12)),
                      child: const Divider(color: Colors.black12, height: 1),
                    ),
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.share_rounded,
                      title: AppLocalizations.of(context).translate('share_app'),
                      onTap: () {
                        Navigator.pop(context);
                        _shareApp(context);
                      },
                    ),
                    _buildDrawerItem(
                      context, r,
                      icon: Icons.star_rate_rounded,
                      title: AppLocalizations.of(context).translate('rate_app'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Version Footer
              Padding(
                padding: EdgeInsets.all(r.s(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_rounded, size: r.s(14), color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    SizedBox(width: r.s(8)),
                    Text(
                      "${AppLocalizations.of(context).translate('version')} 1.1.0",
                      style: GoogleFonts.inter(
                        color: Colors.black26,
                        fontSize: r.sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, Responsive r, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: r.s(4)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primaryGreen : Colors.black45,
          size: r.s(22),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: isActive ? AppColors.primaryGreen : Colors.black87,
            fontSize: r.sp(15),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: r.s(20), vertical: r.s(4)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.s(16)),
        ),
        tileColor: isActive ? AppColors.primaryGreen.withValues(alpha: 0.08) : Colors.transparent,
      ),
    );
  }
}
