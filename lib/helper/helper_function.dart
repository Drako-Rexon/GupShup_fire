import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // * keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // * saving the data to SF

  // * getting the data from SF

  static Future? getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
