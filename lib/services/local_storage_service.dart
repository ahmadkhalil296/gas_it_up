import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String userData = jsonEncode(user.toMap());
    await prefs.setString(_userKey, userData);

  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString(_userKey);
    if (userData == null) return null;

    Map<String, dynamic> data = jsonDecode(userData);
    return UserModel.fromMap(data);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
  Future<void> save(String key,String entity) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$key',entity);

  }

  Future<String> get(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString('$key')!;

  }
}
