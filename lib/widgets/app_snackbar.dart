import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/responsive.dart';

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
    final r = Responsive(context);
    
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(12)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(r.s(16)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: r.s(12),
                offset: Offset(0, r.s(4)),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: r.s(24)),
              SizedBox(width: r.s(12)),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: r.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(
          bottom: r.screenHeight * 0.02,
          left: r.s(16),
          right: r.s(16),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Static method for global access when context is available via key
  // Safe to use a hardcoded value here, or we can look up context if available
  static void showGlobalError(GlobalKey<ScaffoldMessengerState> key, String message) {
    final state = key.currentState;
    if (state == null) return;

    // Use current context if available to get scaling, otherwise use hardcoded fallback
    BuildContext? ctx = key.currentContext;
    double scale = 1.0;
    if (ctx != null) {
      scale = Responsive(ctx).s(1.0);
    }
    
    double s(double val) => val * scale;

    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: s(16), vertical: s(12)),
          decoration: BoxDecoration(
            color: const Color(0xFFC62828).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(s(16)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC62828).withValues(alpha: 0.2),
                blurRadius: s(12),
                offset: Offset(0, s(4)),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: s(24)),
              SizedBox(width: s(12)),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: s(14), // Approx equivalent scaling for text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(s(16)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
