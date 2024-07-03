import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/exceptions/token_not_valid_exception.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/server.dart';

class JournalService {
  http.Client client = Server.client;

  Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<List<Journal>> getAll({
    required int? userId,
    required String? userToken,
  }) async {
    headers.addAll({'authorization': 'Bearer $userToken'});

    http.Response resp = await client.get(
      Server.getUrl(resource: 'users/$userId/journals'),
      headers: headers,
    );

    if (resp.statusCode != 200) {
      if (jsonDecode(resp.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(resp.body);
    }

    List<Journal> list = [];
    List<dynamic> respList = jsonDecode(resp.body);

    for (var item in respList) {
      list.add(Journal.fromMap(item));
    }

    return list;
  }

  Future<bool> register(Journal journal, String userToken) async {
    final String content = jsonEncode(journal.toMap());
    headers.addAll({'authorization': 'Bearer $userToken'});
    journal.id = const Uuid().v1();

    http.Response resp = await client.post(
      Server.getUrl(resource: 'journals'),
      headers: headers,
      body: content,
    );

    if (resp.statusCode != 201) {
      if (jsonDecode(resp.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(resp.body);
    }

    return true;
  }

  Future<bool> edit(String id, Journal journal, String userToken) async {
    final String content = jsonEncode(journal.toMap());
    headers.addAll({'authorization': 'Bearer $userToken'});

    http.Response resp = await client.put(
      Server.getUrl(resource: 'journals', param: id),
      headers: headers,
      body: content,
    );

    if (resp.statusCode != 201) {
      if (jsonDecode(resp.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(resp.body);
    }

    return true;
  }

  Future<bool> delete(String target, String userToken) async {
    headers.addAll({'authorization': 'Bearer $userToken'});

    http.Response resp = await client.delete(
        Server.getUrl(resource: 'journals', param: target),
        headers: headers);

    if (resp.statusCode != 201) {
      if (jsonDecode(resp.body) == 'jwt expired') {
        throw TokenNotValidException();
      }

      throw HttpException(resp.body);
    }

    return true;
  }
}
