import 'package:clean_news/news/data/client/articles_api.dart';
import 'package:clean_news/news/data/model/responses/everything_response.dart';
import 'package:clean_news/shared/data/client/base_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBaseClient extends Mock implements BaseClient {}

void main() {
  late BaseClient mockBaseClient;

  setUp(() {
    mockBaseClient = MockBaseClient();
  });

  test('Gets Articles', () async {
    const mockResponse = EverythingResponse(10, []);

    when(
      () => mockBaseClient.get(
        path: any(named: 'path'),
        fromJson: EverythingResponse.fromJson,
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async => mockResponse);

    final api = ArticlesApi(mockBaseClient);
    final response = await api.getTopHeadlines();

    expect(response, mockResponse);
  });
}
