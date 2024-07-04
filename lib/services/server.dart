import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;

class Server {
  static const String _host = '10.90.1.237'; //192.168.5.165 //10.90.1.237
  static const String _port = '3000';
  static const String _url = 'http://$_host:$_port';

  static getUrl({required String resource, String? param}) {
    if (param != null && param.isNotEmpty) {
      return Uri.parse('$_url/$resource/$param');
    }

    return Uri.parse('$_url/$resource');
  }

  static http.Client get client => InterceptedClient.build(
        interceptors: [LoggerInterceptor()],
        requestTimeout: const Duration(seconds: 15),
      );
}
