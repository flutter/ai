import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  Settings._();

  static SharedPreferencesWithCache? _prefs;

  static Future<void> init() async {
    assert(_prefs == null, 'call Settings.init() exactly once');
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
  }

  static String get foodPreferences {
    assert(_prefs != null, 'call Settings.init() exactly once');
    return _prefs!.getString('foodPreferences') ?? '';
  }

  static Future<void> setFoodPreferences(String value) async {
    assert(_prefs != null, 'call Settings.init() exactly once');
    await _prefs!.setString('foodPreferences', value);
  }
}
