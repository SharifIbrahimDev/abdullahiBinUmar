import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/responsive.dart';
import '../l10n/app_localizations.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          AppLocalizations.of(context).translate('about_sheikh'),
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
                  image: AssetImage('assets/images/abdullah.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: r.s(24)),
            Text(
              "Sheikh Abdullahi Bin Umar",
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: r.sp(28),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(6)),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(r.s(20)),
              ),
              child: Text(
                AppLocalizations.of(context).translate('sheikh_role'),
                style: GoogleFonts.lato(
                  fontSize: r.sp(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: r.s(40)),
            _buildInfoCard(r,
              title: AppLocalizations.of(context).translate('sheikh_bio_title'),
              content: AppLocalizations.of(context).translate('sheikh_bio_content'),
            ),
            SizedBox(height: r.s(24)),
            Text(
              AppLocalizations.of(context).translate('contact_sheikh'),
              style: GoogleFonts.outfit(
                fontSize: r.sp(20),
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            SizedBox(height: r.s(16)),
            Container(
              padding: EdgeInsets.symmetric(vertical: r.s(16)),
              child: Wrap(
                spacing: r.s(12),
                runSpacing: r.s(12),
                alignment: WrapAlignment.center,
                children: [
                  _buildSocialButton(r,
                    icon: Icons.phone_rounded,
                    onTap: () => _launchUrl('tel:08060698938'),
                  ),
                  _buildSocialButton(r,
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    onTap: () => _launchUrl('https://wa.me/2348060698938'),
                  ),
                  _buildSocialButton(r,
                    icon: Icons.email_outlined,
                    onTap: () => _launchUrl('mailto:abdullahibinumar88@gmail.com'),
                  ),
                  _buildSocialButton(r,
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: AppColors.accentGold,
                    onTap: () => _launchUrl('https://chat.whatsapp.com/Kt82MeRsICxFsCF7BJky8t'),
                  ),
                  _buildSocialButton(r,
                    icon: FontAwesomeIcons.telegram,
                    iconColor: const Color(0xFF0088CC),
                    onTap: () => _launchUrl('https://t.me/sharhushadibiyyah'),
                  ),
                ],
              ),
            ),
            SizedBox(height: r.s(48)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Responsive r, {required String title, required String content}) {
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

  Widget _buildSocialButton(Responsive r, {
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final buttonSize = r.s(52).clamp(44.0, 60.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
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
