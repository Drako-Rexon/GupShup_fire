import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // * keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // * saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsernameSF(bool username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(usernameKey, username);
  }

  static Future<bool> saveUserEmailSF(bool userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userEmailKey, userEmail);
  }

  // * getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
