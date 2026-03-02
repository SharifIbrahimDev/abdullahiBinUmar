import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

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
        iconTheme: IconThemeData(color: AppColors.primaryGreen),
        title: Text(
          "About Developer",
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
            // Developer Avatar
            Container(
              width: r.s(140),
              height: r.s(140),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentGold, width: r.s(4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: r.s(30),
                    offset: Offset(0, r.s(15)),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/developer.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: r.s(24)),
            Text(
              "Ibrahim Sharif Abubakar",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: r.sp(26),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(6)),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(r.s(20)),
              ),
              child: Text(
                "Full-Stack Mobile & Web Developer",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: r.sp(13),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B6B23),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: r.s(40)),

            // About Me
            _buildDevCard(r,
              title: "Meet the Developer",
              content: "I am a passionate software engineer specializing in building high-quality, premium mobile and web applications. My goal is to combine robust functionality with exceptional user experience.",
            ),

            SizedBox(height: r.s(24)),

            // Skills/Stack
            _buildDevCard(r,
              title: "Expertise",
              content: "• Flutter & Dart\n• PHP & Laravel\n• Firebase Integration\n• State Management (Provider, Bloc)\n• Clean Architecture\n• UI/UX Design Optimization",
            ),

            SizedBox(height: r.s(32)),

            Text(
              "Connect with Me",
              style: GoogleFonts.outfit(
                fontSize: r.sp(20),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(16)),

            // Social Icons — use Wrap for small screens
            Wrap(
              spacing: r.s(12),
              runSpacing: r.s(12),
              alignment: WrapAlignment.center,
              children: [
                _buildSocialIcon(r,
                  icon: Icons.phone_rounded,
                  onTap: () => _launchUrl('tel:09033065454'),
                ),
                _buildSocialIcon(r,
                  icon: FontAwesomeIcons.whatsapp,
                  iconColor: const Color(0xFF25D366),
                  onTap: () => _launchUrl('https://wa.me/2349033065454'),
                ),
                _buildSocialIcon(r,
                  icon: Icons.email_rounded,
                  onTap: () => _launchUrl('mailto:iasharif114@gmail.com'),
                ),
                _buildSocialIcon(r,
                  icon: FontAwesomeIcons.github,
                  onTap: () => _launchUrl('https://github.com/SharifIbrahimDev'),
                ),
                _buildSocialIcon(r,
                  icon: FontAwesomeIcons.globe,
                  iconColor: AppColors.primaryGreen,
                  onTap: () => _launchUrl('https://sharifibrahimdev.github.io'),
                ),
                _buildSocialIcon(r,
                  icon: FontAwesomeIcons.linkedin,
                  iconColor: const Color(0xFF0077B5),
                  onTap: () => _launchUrl('https://linkedin.com/in/sharif-ibrahim'),
                ),
              ],
            ),
            SizedBox(height: r.s(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildDevCard(Responsive r, {required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.s(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(24)),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: r.s(10),
            offset: Offset(0, r.s(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: r.sp(18),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: r.s(12)),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: r.sp(15),
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(Responsive r, {
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final size = r.s(50).clamp(44.0, 58.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (iconColor ?? AppColors.primaryGreen).withOpacity(0.12),
              blurRadius: r.s(15),
              offset: Offset(0, r.s(6)),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primaryGreen, size: r.s(22)),
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
