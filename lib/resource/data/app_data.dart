/// ============================================================================
/// APP DATA — Path registry for static JSON assets.
/// ============================================================================
class AppData {
  AppData._();

  static const String _base = 'lib/resource/data';

  /// JSON list of transaction categories with id, name, icon, color
  static const String categories = '$_base/categories.json';

  /// JSON map of supported currencies with code, symbol, name
  static const String currencies = '$_base/currencies.json';

  /// JSON list of financial tips for the user
  static const String tips = '$_base/tips.json';

  /// JSON list of onboarding screen configurations
  static const String onboarding = '$_base/onboarding.json';
}
