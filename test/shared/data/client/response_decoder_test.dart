import 'package:clean_news/shared/data/client/response_decoder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('decodes correctly', () {
    const testKey1 = 'testKey1';
    const testKey2 = 'testKey2';
    const testValue1 = 'testValue';
    const testValue2 = 2;

    const testBody = '{"$testKey1": "$testValue1", "$testKey2": $testValue2}';
    final response = http.Response(testBody, 200);
    const decoder = ResponseDecoder();

    final result = decoder.decode(response.bodyBytes);
    expect(result[testKey1], testValue1);
    expect(result[testKey2], testValue2);
  });
}
