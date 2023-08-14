import 'package:clean_news/news/data/database/articles_database.dart';
import 'package:clean_news/news/data/model/entity/article_entity.dart';
import 'package:clean_news/shared/data/database/base_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBaseDatabase extends Mock implements BaseDatabase {}

void main() {
  ArticleEntity buildArticleEntity(String suffix) {
    return ArticleEntity(
      0,
      'sourceId$suffix',
      'sourceName$suffix',
      'author$suffix',
      'title$suffix',
      'description$suffix',
      'content$suffix',
      'publishedAt$suffix',
      true,
    );
  }

  late BaseDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockBaseDatabase();
  });

  ArticlesDatabase getArticlesDatabase() {
    return ArticlesDatabase(mockDatabase);
  }

  test('saveArticle saves correctly', () async {
    final mockArticleEntityA = buildArticleEntity('A');
    when(() => mockDatabase.insert(any(), any())).thenAnswer((_) async => 0);

    final articlesDatabase = getArticlesDatabase();
    await articlesDatabase.saveArticle(mockArticleEntityA);

    final captured =
        verify(() => mockDatabase.insert(any(), captureAny())).captured;

    final capturedMap = captured.first as Map<String, dynamic>;
    expect(capturedMap, mockArticleEntityA.toJson());
  });

  test('loadArticles returns from database', () async {
    final mockArticleA = buildArticleEntity('A');
    final mockArticleB = buildArticleEntity('B');
    final mockArticleC = buildArticleEntity('C');

    final mockList = [
      mockArticleA.toJson(),
      mockArticleB.toJson(),
      mockArticleC.toJson(),
    ];
    when(() => mockDatabase.query(any())).thenAnswer((_) async => mockList);

    final articlesDatabase = getArticlesDatabase();
    final result = await articlesDatabase.loadArticles();

    expect(result.length, 3);
    expect(result[0].toJson(), mockArticleA.toJson());
    expect(result[1].toJson(), mockArticleB.toJson());
    expect(result[2].toJson(), mockArticleC.toJson());
  });

  test('close closes database', () async {
    when(() => mockDatabase.close()).thenAnswer((_) => Future.value());

    final articlesDatabase = getArticlesDatabase();
    await articlesDatabase.close();

    verify(() => mockDatabase.close()).called(1);
  });
}
