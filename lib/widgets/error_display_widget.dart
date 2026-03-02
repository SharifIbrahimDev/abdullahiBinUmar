import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/responsive.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.s(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(r.s(24)),
              decoration: BoxDecoration(
                color: const Color(0xFFC62828).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFC62828),
                size: r.s(64),
              ),
            ),
            SizedBox(height: r.s(24)),
            Text(
              "Oops!",
              style: GoogleFonts.outfit(
                fontSize: r.sp(24),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: r.s(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: r.sp(16),
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: r.s(32)),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, size: r.s(20)),
                label: Text("Try Again", style: TextStyle(fontSize: r.sp(14))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: r.s(24), vertical: r.s(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(r.s(16)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
