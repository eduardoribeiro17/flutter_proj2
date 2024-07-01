import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/server.dart';

class JournalService {
  http.Client client = Server.client;

  Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<List<Journal>> getAll({
    required String userId,
    required userToken,
  }) async {
    headers.addAll({'authorization': userToken});

    http.Response resp = await client.get(
      Server.getUrl(resource: 'users/$userId/journals'),
      headers: headers,
    );

    if (resp.statusCode != 200) throw Exception();

    List<Journal> list = [];
    List<dynamic> respList = jsonDecode(resp.body);

    for (var item in respList) {
      list.add(Journal.fromMap(item));
    }

    return list;
  }

  Future<bool> register(Journal journal) async {
    journal.id = const Uuid().v1();
    final String content = jsonEncode(journal.toMap());

    http.Response resp = await client.post(
      Server.getUrl(resource: 'journals'),
      headers: headers,
      body: content,
    );

    return resp.statusCode == 201;
  }

  Future<bool> edit(String id, Journal journal) async {
    final String content = jsonEncode(journal.toMap());

    http.Response resp = await client.put(
      Server.getUrl(resource: 'journals', param: id),
      headers: headers,
      body: content,
    );

    return resp.statusCode == 200;
  }

  Future<bool> delete(String target) async {
    http.Response resp = await client.delete(
      Server.getUrl(resource: 'journals', param: target),
    );

    return resp.statusCode == 200;
  }
}
