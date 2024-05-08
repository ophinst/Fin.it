import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _uid;
  String? _name;
  String? _token;

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('uid') ?? '';
    _name = prefs.getString('name') ?? '';
    _token = prefs.getString('token') ?? '';
    notifyListeners();
    saveUserData();
  }

  // Save user data to SharedPreferences
  void saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', _uid!);
    prefs.setString('name', _name!);
    prefs.setString('token', _token!);
  }

  // Methods to update user's data
  void updateUserData(String uid, String name, String token) {
    _uid = uid;
    _name = name;
    _token = token;
    notifyListeners(); // Notify the listeners about the change
  }

  //method to remove user data when logout
  Future<void> logout() async {
    _uid = null;
    _name = null;
    _token = null;
    notifyListeners(); // Notify listeners about the change
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('name');
    prefs.remove('token');
  }

  String? get uid => _uid;
  String? get name => _name;
  String? get token => _token;
}
