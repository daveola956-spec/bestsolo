import 'package:flutter/material.dart';

// ── String extensions ─────────────────────────────────────────────────────

extension StringX on String {
  /// Capitalise first letter only
  String get capitalise =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Title case every word
  String get titleCase => split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  /// Truncate with ellipsis
  String truncate(int max) =>
      length > max ? '${substring(0, max)}…' : this;

  /// Parse safely, returns null instead of throwing
  int? get toIntOrNull => int.tryParse(this);
  double? get toDoubleOrNull => double.tryParse(this);

  /// Checks if is a valid email (lightweight)
  bool get isEmail => RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(this);

  /// Remove extra whitespace
  String get clean => trim().replaceAll(RegExp(r'\s+'), ' ');
}

extension StringNullX on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String get orEmpty => this ?? '';
}

// ── num extensions ────────────────────────────────────────────────────────

extension NumX on num {
  bool between(num min, num max) => this >= min && this <= max;
  double get doubleValue => toDouble();
}

// ── BuildContext extensions ───────────────────────────────────────────────

extension BuildContextX on BuildContext {
  // ThemeData / Colors / TextTheme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // MediaQuery shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get padding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // Responsiveness
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // Navigation helpers
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // Snackbar
  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Theme.of(this).colorScheme.error
              : const Color(0xFF333333),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

// ── DateTime extensions ───────────────────────────────────────────────────

extension DateTimeX on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay =>
      DateTime(year, month, day, 23, 59, 59, 999);
}

// ── List extensions ───────────────────────────────────────────────────────

extension ListX<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  List<T> get unique => toSet().toList();
}