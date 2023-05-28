import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  addIntToSF(key, values) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, values);
  }

  addStrListSp(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  getIntValuesSF(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  getStringListSp(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  removeValues(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
