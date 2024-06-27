import 'package:http/http.dart' as http;

class JornalService {
  static const String url = 'http://localhost:58384/';
  static const String resource = 'learnhttp';

  String getUrl() => '$url$resource';

  register(String content) {
    http.post(Uri.parse(getUrl()), body: {"content": content});
  }
}
