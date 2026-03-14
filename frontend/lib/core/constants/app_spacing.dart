import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // ── Base scale (4pt grid) ─────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ── Named semantic spacings ───────────────────────────────────────────────
  static const double sectionGap = 40.0;
  static const double cardPadding = 16.0;
  static const double pagePadding = 20.0;
  static const double inputGap = 16.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeSm = 18.0;
  static const double iconSizeLg = 32.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLg = 12.0;
  static const double borderRadiusXl = 16.0;
  static const double borderRadiusFull = 100.0;

  // ── Grid ──────────────────────────────────────────────────────────────────
  static const double productCardWidth = 200.0;
  static const double productCardHeight = 280.0;
  static const double productImageHeight = 200.0;

  // ── Breakpoints ───────────────────────────────────────────────────────────
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1280.0;
  static const double maxContentWidth = 1200.0;

  // ── SizedBox shortcuts ────────────────────────────────────────────────────
  static const Widget gapXs = SizedBox(height: xs, width: xs);
  static const Widget gapSm = SizedBox(height: sm, width: sm);
  static const Widget gapMd = SizedBox(height: md, width: md);
  static const Widget gapLg = SizedBox(height: lg, width: lg);
  static const Widget gapXl = SizedBox(height: xl, width: xl);

  static const Widget hGapXs = SizedBox(width: xs);
  static const Widget hGapSm = SizedBox(width: sm);
  static const Widget hGapMd = SizedBox(width: md);
  static const Widget hGapLg = SizedBox(width: lg);

  static const Widget vGapXs = SizedBox(height: xs);
  static const Widget vGapSm = SizedBox(height: sm);
  static const Widget vGapMd = SizedBox(height: md);
  static const Widget vGapLg = SizedBox(height: lg);
  static const Widget vGapXl = SizedBox(height: xl);
  static const Widget vGapXxl = SizedBox(height: xxl);

  // ── EdgeInsets shortcuts ──────────────────────────────────────────────────
  static const EdgeInsets pagePaddingAll =
      EdgeInsets.symmetric(horizontal: pagePadding, vertical: pagePadding);
  static const EdgeInsets horizontalPagePadding =
      EdgeInsets.symmetric(horizontal: pagePadding);
  static const EdgeInsets cardPaddingAll = EdgeInsets.all(cardPadding);
}