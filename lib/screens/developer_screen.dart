import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: AppColors.primaryGreen),
        title: Text(
          "About Developer",
          style: GoogleFonts.outfit(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Developer Avatar
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentGold, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/developer.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Ibrahim Sharif Abubakar",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Full-Stack Mobile & Web Developer",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B6B23),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // About Me
            _buildDevCard(
              title: "Meet the Developer",
              content: "I am a passionate software engineer specializing in building high-quality, premium mobile and web applications. My goal is to combine robust functionality with exceptional user experience.",
            ),
            
            const SizedBox(height: 24),
            
            // Skills/Stack
            _buildDevCard(
              title: "Expertise",
              content: "• Flutter & Dart\n• PHP & Laravel\n• Firebase Integration\n• State Management (Provider, Bloc)\n• Clean Architecture\n• UI/UX Design Optimization",
            ),
            
            const SizedBox(height: 32),
            
            Text(
              "Connect with Me",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            
            // Social Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialIcon(
                  icon: Icons.phone_rounded,
                  onTap: () => _launchUrl('tel:09033065454'),
                ),
                _buildSocialIcon(
                  icon: FontAwesomeIcons.whatsapp,
                  iconColor: const Color(0xFF25D366),
                  onTap: () => _launchUrl('https://wa.me/2349033065454'),
                ),
                _buildSocialIcon(
                  icon: Icons.email_rounded,
                  onTap: () => _launchUrl('mailto:iasharif114@gmail.com'),
                ),
                _buildSocialIcon(
                  icon: FontAwesomeIcons.github,
                  onTap: () => _launchUrl('https://github.com/SharifIbrahimDev'),
                ),
                _buildSocialIcon(
                  icon: FontAwesomeIcons.globe,
                  iconColor: AppColors.primaryGreen,
                  onTap: () => _launchUrl('https://sharifibrahimdev.github.io'),
                ),
                _buildSocialIcon(
                  icon: FontAwesomeIcons.linkedin,
                  iconColor: const Color(0xFF0077B5),
                  onTap: () => _launchUrl('https://linkedin.com/in/sharif-ibrahim'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDevCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (iconColor ?? AppColors.primaryGreen).withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primaryGreen, size: 22),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }
}
