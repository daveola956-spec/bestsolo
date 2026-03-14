/// Custom validators that work with both FormBuilderValidators
/// and standalone form fields.
class AppValidators {
  AppValidators._();

  // ── Email ─────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ── Password ──────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String? original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Please confirm your password';
      if (value != original) return 'Passwords do not match';
      return null;
    };
  }

  // ── Phone (Nigerian) ──────────────────────────────────────────────────────
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    // Allow +234XXXXXXXXXX or 0XXXXXXXXXX (11 digits)
    final regex = RegExp(r'^(?:\+234|0)[789]\d{9}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Enter a valid Nigerian phone number';
    }
    return null;
  }

  // ── Required ──────────────────────────────────────────────────────────────
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  // ── Name ──────────────────────────────────────────────────────────────────
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    if (!value.trim().contains(' ')) return 'Enter your first and last name';
    return null;
  }

  // ── Min / Max length ──────────────────────────────────────────────────────
  static String? Function(String?) minLength(int min, {String? label}) {
    return (String? value) {
      if (value == null || value.length < min) {
        return '${label ?? 'This field'} must be at least $min characters';
      }
      return null;
    };
  }

  static String? Function(String?) maxLength(int max, {String? label}) {
    return (String? value) {
      if (value != null && value.length > max) {
        return '${label ?? 'This field'} must not exceed $max characters';
      }
      return null;
    };
  }

  // ── Combine validators ────────────────────────────────────────────────────
  static String? Function(String?) compose(
      List<String? Function(String?)> validators) {
    return (String? value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}