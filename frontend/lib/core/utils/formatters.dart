import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  // ── Currency (₦) ──────────────────────────────────────────────────────────
  static final _naira = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 0,
  );

  static final _nairaDecimal = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2,
  );

  /// e.g. ₦25,000
  static String naira(num amount) => _naira.format(amount);

  /// e.g. ₦25,000.00
  static String nairaDecimal(num amount) => _nairaDecimal.format(amount);

  /// e.g. ₦1.5K or ₦2.3M
  static String nairaCompact(num amount) {
    if (amount >= 1000000) {
      return '₦${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '₦${(amount / 1000).toStringAsFixed(1)}K';
    }
    return naira(amount);
  }

  // ── Dates ─────────────────────────────────────────────────────────────────
  static final _dateShort = DateFormat('dd MMM yyyy');
  static final _dateLong = DateFormat('EEEE, dd MMMM yyyy');
  static final _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final _timeOnly = DateFormat('hh:mm a');

  /// e.g. 13 Mar 2026
  static String date(DateTime dt) => _dateShort.format(dt);

  /// e.g. Friday, 13 March 2026
  static String dateLong(DateTime dt) => _dateLong.format(dt);

  /// e.g. 13 Mar 2026, 06:45 PM
  static String dateTime(DateTime dt) => _dateTime.format(dt);

  /// e.g. 06:45 PM
  static String time(DateTime dt) => _timeOnly.format(dt);

  /// Relative — "just now", "2 hours ago", "3 days ago"
  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dt);
  }

  // ── Phone ─────────────────────────────────────────────────────────────────
  /// Normalises to +234XXXXXXXXXX format
  static String normalizePhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.startsWith('0') && cleaned.length == 11) {
      return '+234${cleaned.substring(1)}';
    }
    if (cleaned.startsWith('234') && cleaned.length == 13) {
      return '+$cleaned';
    }
    return phone;
  }

  // ── Numbers ───────────────────────────────────────────────────────────────
  static String compact(num value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }

  // ── Order / Status ────────────────────────────────────────────────────────
  /// e.g. "order_items" → "Order Items"
  static String snakeToTitle(String s) {
    return s
        .split('_')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  /// Mask sensitive strings — e.g. email to "a****@gmail.com"
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final masked = name.length > 2
        ? '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}'
        : name;
    return '$masked@${parts[1]}';
  }
}