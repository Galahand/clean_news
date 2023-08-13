import '../../../shared/data/client/base_client.dart';
import '../../../shared/data/client/error_emitter.dart';
import '../../../shared/data/client/response_decoder.dart';
import '../model/responses/everything_response.dart';

class ArticlesApi {
  const ArticlesApi(this.client);

  final BaseClient client;

  Future<EverythingResponse> getTopHeadlines({
    String? country = 'us',
    int? pageSize,
    int? page,
  }) {
    return client.get(
      path: '/v2/top-headlines',
      fromJson: EverythingResponse.fromJson,
      queryParameters: {
        'country': country,
        'pageSize': pageSize,
        'page': page,
      },
    );
  }
}

ArticlesApi buildDefaultNewsApi([ErrorEmitter? errorEmitter]) {
  const apiKeyHeader = 'X-Api-Key';
  const apiKey = String.fromEnvironment("NEWS_API_KEY");
  const domain = String.fromEnvironment("NEWS_BASE_URL");

  return ArticlesApi(BaseClient(
    domain,
    const ResponseDecoder(),
    defaultHeaders: const {apiKeyHeader: apiKey},
    errorEmitter: errorEmitter,
  ));
}
