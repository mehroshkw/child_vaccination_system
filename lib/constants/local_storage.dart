import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _sharedPreferences;

  static const String _IS_PARENT = 'SharedPreferenceHelper.isParent';

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future saveString(key, value) async {
    await _sharedPreferences.setString(key, value);
  }

  static String getString(key) {
    return _sharedPreferences.getString(key) ?? '';
  }

  static void removeValue({required String key}) async {
    await _sharedPreferences.remove(key);
  }

  static void removeAll() async {
    await _sharedPreferences.clear();
  }

  Future<void> setIsParent(bool isParent) async {
    await _sharedPreferences.setBool(_IS_PARENT, isParent);
  }

  bool get isClient => _sharedPreferences.getBool(_IS_PARENT) ?? false;
}
