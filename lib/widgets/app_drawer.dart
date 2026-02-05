import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFFAF9F6), // Warm white surface
        child: Column(
          children: [
            // Modern Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40, left: 30, right: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF1B5E20),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Hero(
                    tag: 'drawer_art',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC5A059), width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/bin_umar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                  Text(
                    "Islamic Audio Library",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    title: "About the Reciter",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(color: Colors.black12),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.share_outlined,
                    title: "Share App",
                    onTap: () {
                       Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.star_outline_rounded,
                    title: "Rate App",
                    onTap: () {
                       Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                "Version 1.1.0",
                style: GoogleFonts.inter(
                  color: Colors.black26,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.black54,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            color: isActive ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        selected: isActive,
        selectedTileColor: const Color(0xFF1B5E20),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
