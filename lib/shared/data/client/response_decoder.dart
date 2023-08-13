import 'dart:convert';
import 'dart:typed_data';

class ResponseDecoder {
  const ResponseDecoder();

  Map<String, dynamic> decode(Uint8List bodyBytes) {
    return jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
  }
}
