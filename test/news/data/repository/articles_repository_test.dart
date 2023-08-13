import 'package:clean_news/news/data/client/articles_api.dart';
import 'package:clean_news/news/data/database/articles_database.dart';
import 'package:clean_news/news/data/model/entity/article_entity.dart';
import 'package:clean_news/news/data/model/responses/article_response.dart';
import 'package:clean_news/news/data/model/responses/everything_response.dart';
import 'package:clean_news/news/data/model/responses/source_response.dart';
import 'package:clean_news/news/data/repository/articles_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticlesApi extends Mock implements ArticlesApi {}

class MockArticlesDatabase extends Mock implements ArticlesDatabase {}

void main() {
  const mockArticleResponse = ArticleResponse(
    SourceResponse('someId', 'someName'),
    'someAuthor',
    'someTitle',
    'someDescription',
    'someContent',
    'somePublishedAt',
  );
  const mockHeadlinesResponse = EverythingResponse(1, [mockArticleResponse]);
  const mockArticleEntity = ArticleEntity(
    0,
    'sourceId',
    'sourceName',
    'author',
    'title',
    'description',
    'content',
    'publishedAt',
    true,
  );

  late ArticlesApi mockArticlesApi;
  late ArticlesDatabase mockArticlesDatabase;

  setUp(() {
    mockArticlesApi = MockArticlesApi();
    mockArticlesDatabase = MockArticlesDatabase();
  });

  setUpAll(() {
    registerFallbackValue(mockArticleEntity);
  });

  ArticlesRepository buildTestRepository() {
    return ArticlesRepository(mockArticlesApi, mockArticlesDatabase);
  }

  test('refreshArticleHeaders updates to stream with correct data', () async {
    ArticleEntity? mightBeEmitted;

    when(() => mockArticlesApi.getTopHeadlines(country: any(named: 'country')))
        .thenAnswer((_) async => mockHeadlinesResponse);

    final repository = buildTestRepository();
    repository.headlinesStream.listen((event) {
      mightBeEmitted = event.first;
    });

    await repository.refreshArticleHeaders();
    await Future.value();

    final emitted = mightBeEmitted!;
    expect(emitted.content, mockArticleResponse.content);
    expect(emitted.title, mockArticleResponse.title);
    expect(emitted.description, mockArticleResponse.description);
    expect(emitted.author, mockArticleResponse.author);
    expect(emitted.publishedAt, mockArticleResponse.publishedAt);
    expect(emitted.sourceId, mockArticleResponse.source.id);
    expect(emitted.sourceName, mockArticleResponse.source.name);
    expect(emitted.saved, false);
  });

  test('saveArticle saves in database with saved as true', () async {
    when(() => mockArticlesApi.getTopHeadlines(country: any(named: 'country')))
        .thenAnswer((_) async => mockHeadlinesResponse);
    when(() => mockArticlesDatabase.saveArticle(any()))
        .thenAnswer((_) async => mockArticleEntity);

    final repository = buildTestRepository();
    await repository.refreshArticleHeaders();
    await repository.saveArticle(0);

    final savedArticle = verify(
      () => mockArticlesDatabase.saveArticle(captureAny()),
    ).captured.first as ArticleEntity;

    expect(savedArticle.content, mockArticleResponse.content);
    expect(savedArticle.title, mockArticleResponse.title);
    expect(savedArticle.description, mockArticleResponse.description);
    expect(savedArticle.author, mockArticleResponse.author);
    expect(savedArticle.publishedAt, mockArticleResponse.publishedAt);
    expect(savedArticle.sourceId, mockArticleResponse.source.id);
    expect(savedArticle.sourceName, mockArticleResponse.source.name);
    expect(savedArticle.id, null);
    expect(savedArticle.saved, true);
  });
}
