class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (RegExp(r'\d').hasMatch(v)) return 'Name cannot contain digits';
    if (v.trim().length < 2) return 'Name is too short';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.\w{2,}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters required';
    return null;
  }

  static String? Function(String?) confirmPassword(String original) =>
      (String? v) => v != original ? 'Passwords do not match' : null;

  static String? machineName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    return null;
  }
}
