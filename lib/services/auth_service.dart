import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_webapi_first_course/services/server.dart';
import 'package:flutter_webapi_first_course/exceptions/user_not_find_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final http.Client _client = Server().client;

  Future<bool> login({required String email, required String password}) async {
    http.Response resp = await _client.post(
      Server.getUrl(resource: 'login'),
      body: {'email': email, 'password': password},
    );

    if (resp.statusCode != 200) {
      String content = jsonDecode(resp.body);

      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }

      throw HttpException(resp.body);
    }

    saveUserInfo(resp.body);
    return true;
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    http.Response resp = await _client.post(
      Server.getUrl(resource: 'register'),
      body: {'email': email, 'password': password},
    );

    if (resp.statusCode != 201) throw HttpException(resp.body);

    saveUserInfo(resp.body);
    return true;
  }

  saveUserInfo(String body) async {
    Map<String, dynamic> map = jsonDecode(body);

    String token = map['accessToken'];
    String email = map['user']['email'];
    int id = map['user']['id'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
    prefs.setString('email', email);
    prefs.setInt('id', id);
  }
}
