import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          "About Sheikh",
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
                  image: AssetImage('assets/images/abdullah.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Sheikh Abdullahi Bin Umar",
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Malamin Addini & Mai Wa'azi",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              title: "Biography",
              content: "Sheikh Abdullahi Bin Umar is a renowned Islamic scholar dedicated to teaching the Quran and Hadith. His explanations of classical texts like 'Sharhu Ilalit Tirmizi' and 'Usulu Riwayati Qalun' have benefited thousands of students.",
            ),
            const SizedBox(height: 24),
            Text(
              "Contact Sheikh",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.phone_rounded,
                    onTap: () => _launchUrl('tel:08060698938'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    onTap: () => _launchUrl('https://wa.me/2348060698938'),
                  ),
                  _buildSocialButton(
                    icon: Icons.email_outlined,
                    onTap: () => _launchUrl('mailto:abdullahibinumar88@gmail.com'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: AppColors.accentGold, // Different shade for group
                    onTap: () => _launchUrl('https://chat.whatsapp.com/Kt82MeRsICxFsCF7BJky8t'),
                  ),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.telegram,
                    iconColor: const Color(0xFF0088CC),
                    onTap: () => _launchUrl('https://t.me/sharhushadibiyyah'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
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

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
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
        child: Icon(icon, color: iconColor ?? AppColors.primaryGreen, size: 24),
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
