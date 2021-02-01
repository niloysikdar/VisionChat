import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String userIdkey = "USERKEY";
  static String userNamekey = "USERNAMEKEY";
  static String displayNamekey = "DISPLAYNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";
  static String userProfilepickey = "USERPROFILEPICKEY";

  // save data locally

  Future<bool> saveUserId(String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdkey, userid);
  }

  Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNamekey, username);
  }

  Future<bool> saveDisplayName(String displayname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNamekey, displayname);
  }

  Future<bool> saveUserEmail(String useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailkey, useremail);
  }

  Future<bool> saveUserProfilePic(String userprofilepic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilepickey, userprofilepic);
  }

  // get data from sharedprferences

  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdkey);
  }

  Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNamekey);
  }

  Future<String> getDisplayName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(displayNamekey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailkey);
  }

  Future<String> getUserProfilePic() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userProfilepickey);
  }
}
