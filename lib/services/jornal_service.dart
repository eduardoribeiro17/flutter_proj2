import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = 'http://localhost:3000/';
  static const String resource = 'journals/';

  http.Client client =
      InterceptedClient.build(interceptors: [LoggerInterceptor()]);

  getUrl() => Uri.parse('$url$resource');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<bool> register(Journal journal) async {
    print('Content -> $journal');
    final String content = jsonEncode(journal.toMap());

    http.Response resp = await client.post(
      getUrl(),
      headers: _headers,
      body: content,
    );

    return resp.statusCode == 201;
  }

  Future<String> get() async {
    http.Response resp = await client.get(getUrl());

    return resp.body;
  }
}
