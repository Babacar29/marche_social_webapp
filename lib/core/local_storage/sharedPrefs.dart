import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static final SharedPreferencesServices _instance =
  SharedPreferencesServices._ctor();

  factory SharedPreferencesServices() {
    return _instance;
  }

  SharedPreferencesServices._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String getUserRoleFromSharedPref() {
    if (!_prefs.containsKey('UserRole')) {
      return '';
    }
    return _prefs.get('UserRole').toString();
  }

  setUserRoleInSharedPref(String str) {
    _prefs.remove("UserRole");
    _prefs.setString("UserRole", str);
  }
}
