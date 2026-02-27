import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, const Color(0xFF2E7D32), Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, const Color(0xFFC62828), Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, const Color(0xFF1565C0), Icons.info_outline);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Static method for global access when context is available via key
  static void showGlobalError(GlobalKey<ScaffoldMessengerState> key, String message) {
    final state = key.currentState;
    if (state == null) return;

    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC62828).withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
