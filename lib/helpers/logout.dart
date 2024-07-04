import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();

  Navigator.pushReplacementNamed(context, 'login');
}
