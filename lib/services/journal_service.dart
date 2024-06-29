import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:uuid/uuid.dart';

class JournalService {
  static const String _host = '192.168.5.165';
  static const String _port = '3000';
  static const String url = 'http://$_host:$_port/';
  static const String resource = 'journals/';

  http.Client client =
      InterceptedClient.build(interceptors: [LoggerInterceptor()]);

  getUrl({String? param}) {
    if (param != null && param.isNotEmpty) {
      return Uri.parse('$url$resource$param');
    }

    return Uri.parse('$url$resource');
  }

  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<List<Journal>> getAll() async {
    http.Response resp = await client.get(getUrl());

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
      getUrl(),
      headers: _headers,
      body: content,
    );

    return resp.statusCode == 201;
  }

  Future<bool> edit(String id, Journal journal) async {
    final String content = jsonEncode(journal.toMap());

    http.Response resp = await client.put(
      getUrl(param: id),
      headers: _headers,
      body: content,
    );

    return resp.statusCode == 200;
  }

  Future<bool> delete(String target) async {
    http.Response resp = await http.delete(getUrl(param: target));

    return resp.statusCode == 200;
  }
}
