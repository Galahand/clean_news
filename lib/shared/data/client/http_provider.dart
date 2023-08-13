import 'package:http/http.dart' as http;

class HttpProvider {
  const HttpProvider();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return http.get(url, headers: headers);
  }
}
