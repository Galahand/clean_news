import 'dart:async';

import 'package:clean_news/news/data/model/entity/article_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../client/articles_api.dart';
import '../database/articles_database.dart';
import '../model/responses/article_response.dart';

class ArticlesRepository {
  ArticlesRepository(this.api, this.database);

  final ArticlesApi api;
  final ArticlesDatababse database;
  final _articlesSubject = BehaviorSubject<List<ArticleEntity>>();

  Stream<List<ArticleEntity>> get headlinesStream {
    return _articlesSubject.stream;
  }

  Future<void> refreshArticleHeaders([String? country = 'us']) async {
    try {
      final result = await api.getTopHeadlines(country: country);
      final entities = result.articles.map((e) => e.toEntity()).toList();
      _articlesSubject.add(entities);
    } catch (e) {
      _articlesSubject.addError(e);
    }
  }

  Future<void> saveArticle(int index) {
    final article = _articlesSubject.value[index].toggleSaved();
    return database.saveArticle(article);
  }
}

extension on ArticleResponse {
  ArticleEntity toEntity() {
    return ArticleEntity(
      null,
      source.id,
      source.name,
      author,
      title,
      description,
      content,
      publishedAt,
      false,
    );
  }
}

extension on ArticleEntity {
  ArticleEntity toggleSaved() {
    return ArticleEntity(
      id,
      sourceId,
      sourceName,
      author,
      title,
      description,
      content,
      publishedAt,
      !saved,
    );
  }
}
