import 'dart:async';

import 'package:clean_news/news/data/model/entity/article_entity.dart';
import 'package:clean_news/news/data/repository/articles_repository.dart';
import 'package:clean_news/news/ui/articles/model/article.dart';
import 'package:clean_news/news/ui/home_page/controller/home_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticlesRepository extends Mock implements ArticlesRepository {}

void main() {
  const mockArticleEntity = ArticleEntity(
    null,
    'sourceId',
    'sourceName',
    'author',
    'title',
    'description',
    'content',
    'publishedAt',
    false,
  );

  late ArticlesRepository mockArticlesRepository;
  late StreamController<List<ArticleEntity>> mockHeadlinesStream;

  setUp(() {
    mockArticlesRepository = MockArticlesRepository();
    mockHeadlinesStream = StreamController<List<ArticleEntity>>();

    when(() => mockArticlesRepository.headlinesStream)
        .thenAnswer((_) => mockHeadlinesStream.stream);
    when(() => mockArticlesRepository.refreshArticleHeaders(any()))
        .thenAnswer((_) => Future.value());
    when(() => mockArticlesRepository.clear())
        .thenAnswer((_) => Future.value());
  });

  tearDown(() {
    mockHeadlinesStream.close();
  });

  HomeController buildHomeController() {
    return HomeController(mockArticlesRepository);
  }

  test('init subscribes to headlines', () {
    final controller = buildHomeController();

    expect(mockHeadlinesStream.hasListener, isFalse);

    controller.onInit();

    expect(mockHeadlinesStream.hasListener, isTrue);
  });

  test('init calls refreshArticleHeaders', () {
    final controller = buildHomeController();
    controller.onInit();

    verify(() => mockArticlesRepository.refreshArticleHeaders(any())).called(1);
  });

  test('init starts refresh timer', () {
    final controller = buildHomeController();

    controller.onInit();

    expect(controller.refreshTimer.isActive, isTrue);
  });

  test('close cancels subscription', () {
    final controller = buildHomeController();
    controller.onInit();
    controller.onClose();

    expect(mockHeadlinesStream.hasListener, isFalse);
  });

  test('close cancels cancels timer', () {
    final controller = buildHomeController();
    controller.onInit();
    controller.onClose();

    expect(controller.refreshTimer.isActive, isFalse);
  });

  test('close cancels closes articles stream', () {
    final controller = buildHomeController();
    controller.onInit();
    controller.onClose();

    expect(controller.articles.subject.isClosed, isTrue);
  });

  test('close clears repository', () {
    final controller = buildHomeController();
    controller.onInit();
    controller.onClose();

    verify(() => mockArticlesRepository.clear()).called(1);
  });

  test('articles first state is loading', () async {
    final controller = buildHomeController();

    final isLoading = controller.articles().when<bool>(
          (data) => false,
          (error) => false,
          () => true,
        );

    expect(isLoading, isTrue);
  });

  test('headlinesStream success updates emits articles', () async {
    final mockList = <ArticleEntity>[mockArticleEntity];
    final controller = buildHomeController();
    controller.onInit();

    mockHeadlinesStream.add(mockList);

    await Future.value();

    final article = controller.articles().when<Article?>(
          (data) => data.first,
          (error) => null,
          () => null,
        );

    if (article == null) fail('request should be successful');

    expect(article.author, mockArticleEntity.author);
    expect(article.date, mockArticleEntity.publishedAt);
    expect(article.title, mockArticleEntity.title);
    expect(article.description, mockArticleEntity.description);
    expect(article.content, mockArticleEntity.content);
  });

  test(
    'headlinesStream error emits error if previous state was loading',
    () async {
      final mockException = Exception();
      final controller = buildHomeController();
      controller.onInit();

      mockHeadlinesStream.addError(mockException);
      await Future.value();

      final error = controller.articles().when<dynamic>(
            (data) => null,
            (error) => error,
            () => null,
          );

      if (error == null) fail('request should be error');

      expect(error, same(mockException));
    },
  );

  test(
    "headlinesStream error doesn't emit error if previous state wasn't loading",
    () async {
      final mockList = <ArticleEntity>[mockArticleEntity];
      final mockException = Exception();
      final controller = buildHomeController();
      controller.onInit();

      mockHeadlinesStream.add(mockList);
      await Future.value();
      mockHeadlinesStream.addError(mockException);
      await Future.value();

      final article = controller.articles().when<Article?>(
            (data) => data.first,
            (error) => null,
            () => null,
          );

      if (article == null) fail('request should be successful');

      expect(article.author, mockArticleEntity.author);
      expect(article.date, mockArticleEntity.publishedAt);
      expect(article.title, mockArticleEntity.title);
      expect(article.description, mockArticleEntity.description);
      expect(article.content, mockArticleEntity.content);
    },
  );

  test('saveArticle saves article on repository', () {
    when(() => mockArticlesRepository.saveArticle(any()))
        .thenAnswer((_) => Future.value());

    final controller = buildHomeController();
    controller.saveArticle(0);

    verify(() => mockArticlesRepository.saveArticle(0)).called(1);
  });

  test('articles are updated after refreshDuration', () {
    fakeAsync((async) {
      final controller = buildHomeController();
      controller.onInit();

      verify(() => mockArticlesRepository.refreshArticleHeaders(any()))
          .called(1);

      async.elapse(HomeController.refreshDuration);

      verify(() => mockArticlesRepository.refreshArticleHeaders(any()))
          .called(1);

      async.elapse(HomeController.refreshDuration);
      async.elapse(HomeController.refreshDuration);

      verify(() => mockArticlesRepository.refreshArticleHeaders(any()))
          .called(2);
    });
  });
}
