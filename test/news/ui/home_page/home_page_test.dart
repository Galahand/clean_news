import 'package:clean_news/news/ui/home_page/component/article_tile.dart';
import 'package:clean_news/news/ui/home_page/controller/home_controller.dart';
import 'package:clean_news/news/ui/home_page/home_page.dart';
import 'package:clean_news/news/ui/home_page/model/article.dart';
import 'package:clean_news/shared/data/model/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeController extends GetxService
    with Mock
    implements HomeController {}

void main() {
  late Rx<Result<List<Article>>> articles;
  late HomeController mockHomeController;
  setUp(() {
    Get.reset();

    articles = const Result<List<Article>>.loading().obs;
    mockHomeController = MockHomeController();
    when(() => mockHomeController.articles).thenAnswer((_) => articles);
    when(() => mockHomeController.saveArticle(any()))
        .thenAnswer((_) => Future.value());

    Get.put(mockHomeController);
  });

  tearDown(() {
    articles.close();
  });

  testWidgets('shows loading', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows blank screen on error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    articles(Result.error(Exception()));

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows blank screen on error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    articles(Result.error(Exception()));

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows articles on success', (tester) async {
    const mockArticles = [
      Article('authorA', 'titleA', 'descriptionA', 'contentA', 'dateA', false),
      Article('authorB', 'titleB', 'descriptionB', 'contentB', 'dateB', false),
    ];

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    articles(const Result.success(mockArticles));

    await tester.pumpAndSettle();

    expect(find.byType(ArticleTile), findsNWidgets(2));
  });

  testWidgets('tileSaveButton triggers controller saveArticle', (tester) async {
    const mockArticles = [
      Article('authorA', 'titleA', 'descriptionA', 'contentA', 'dateA', false),
    ];

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    articles(const Result.success(mockArticles));

    await tester.pumpAndSettle();
    await tester.tap(find.byType(SaveButton));

    verify(() => mockHomeController.saveArticle(any())).called(1);
  });

  testWidgets('tile displays data correctly', (tester) async {
    const mockArticles = [
      Article('authorA', 'titleA', 'descriptionA', 'contentA', 'dateA', false),
    ];

    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    articles(const Result.success(mockArticles));

    await tester.pumpAndSettle();
    await tester.tap(find.byType(SaveButton));

    verify(() => mockHomeController.saveArticle(any())).called(1);
  });
}
