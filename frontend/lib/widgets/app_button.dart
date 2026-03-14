import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary loading button — shows spinner while loading
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final Widget? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.width,
  });

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isSmall = false,
    this.icon,
    this.width,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final height = isSmall ? 40.0 : 48.0;
    final textStyle = GoogleFonts.inter(
      fontSize: isSmall ? 13 : 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    final child = isLoading
        ? SizedBox(
            width: isSmall ? 16 : 20,
            height: isSmall ? 16 : 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? const Color(0xFF1FAF5A) : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(label, style: textStyle),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1FAF5A),
            side: const BorderSide(color: Color(0xFF1FAF5A), width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 16 : 24, vertical: 0),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1FAF5A),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF1FAF5A).withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 24, vertical: 0),
        ),
        child: child,
      ),
    );
  }
}
