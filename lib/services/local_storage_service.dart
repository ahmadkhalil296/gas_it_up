import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    await prefs.clear(); // This will clear all stored data including map locations
  }

  Future<void> save(String key,String entity) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$key',entity);

  }

  Future<String> get(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString('$key')!;

  }

  /// Retrieves the saved location from local storage
  /// Returns a LatLng object if location exists, null otherwise
  Future<LatLng?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? locationJson = prefs.getString('location');
      if (locationJson == null) return null;

      Map<String, dynamic> locationData = jsonDecode(locationJson);
      return LatLng(
        locationData['latitude'] as double,
        locationData['longitude'] as double,
      );
    } catch (e) {
      print('Error getting saved location: $e');
      return null;
    }
  }

  Future<void> clearMapData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_location');
    await prefs.remove('last_known_location');
    await prefs.remove('recent_addresses');
  }
}
