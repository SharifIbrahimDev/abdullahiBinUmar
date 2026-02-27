import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const platform = MethodChannel('com.example.app/share');

  Future<void> _shareApp() async {
    try {
      if (Platform.isAndroid) {
        final String? apkPath = await platform.invokeMethod('getApkPath');
        if (apkPath != null) {
          await Share.shareXFiles(
            [XFile(apkPath)],
            text: 'Download Sheikh Abdullahi Bin Umar Library App',
          );
        }
      } else {
        await Share.share(
          'Download Sheikh Abdullahi Bin Umar Library App: https://sharifibrahimdev.github.io',
        );
      }
    } catch (e) {
      debugPrint('Sharing failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
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
                padding: const EdgeInsets.fromLTRB(24, 70, 24, 32),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(60)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.accentGold,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: const AssetImage('assets/images/bin_umar.jpg'),
                        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Sheikh Abdullahi\nBin Umar",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Islamic Audio Library",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.grid_view_rounded,
                      title: "Audio Books",
                      onTap: () => Navigator.pop(context),
                      isActive: true,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: "About the Sheikh",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.developer_mode_rounded,
                      title: "About the Developer",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/developer');
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: "About the App",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/app_info');
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Divider(color: Colors.black12, height: 1),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.share_rounded,
                      title: "Share App",
                      onTap: () {
                        Navigator.pop(context);
                        _shareApp();
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.star_rate_rounded,
                      title: "Rate App",
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Version Footer
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_rounded, size: 14, color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    const SizedBox(width: 8),
                    Text(
                      "Version 1.1.0",
                      style: GoogleFonts.inter(
                        color: Colors.black26,
                        fontSize: 12,
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

  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primaryGreen : Colors.black45,
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: isActive ? AppColors.primaryGreen : Colors.black87,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: isActive ? AppColors.primaryGreen.withValues(alpha: 0.08) : Colors.transparent,
      ),
    );
  }
}
