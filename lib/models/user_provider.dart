import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _uid;
  String? _name;
  String? _token;

  // Methods to update user's data
  void updateUserData(String uid, String name, String token) {
    _uid = uid;
    _name = name;
    _token = token;
    notifyListeners(); // Notify the listeners about the change
  }

  String? get uid => _uid;
  String? get name => _name;
  String? get token => _token;
}

