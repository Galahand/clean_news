import 'package:clean_news/news/ui/articles/component/article_tile.dart';
import 'package:clean_news/news/ui/articles/model/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mockArticle = Article(
    'author',
    'title',
    'description',
    'content',
    'date',
  );

  testWidgets('Displays correctly', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleTile(
          article: mockArticle,
          onSaveButtonPressed: () {},
        ),
      ),
    ));

    expect(find.text('${mockArticle.author} | ${mockArticle.date}'),
        findsOneWidget);
    expect(find.text(mockArticle.title), findsOneWidget);
    expect(find.text(mockArticle.description!), findsOneWidget);
    expect(find.text(mockArticle.content!), findsOneWidget);
    expect(find.byType(SaveButton), findsOneWidget);
  });

  testWidgets('Save button tap triggers onSaveButtonPressed', (tester) async {
    var tapped = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleTile(
          article: mockArticle,
          onSaveButtonPressed: () {
            tapped = true;
          },
        ),
      ),
    ));

    await tester.tap(find.byType(SaveButton));
    expect(tapped, isTrue);
  });
}
