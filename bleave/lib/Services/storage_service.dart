import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveLoginInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  Future<String?> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

 Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }


}