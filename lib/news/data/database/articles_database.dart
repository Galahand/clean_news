import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../../shared/data/database/base_database.dart';
import '../model/entity/article_entity.dart';

class ArticlesDatabase {
  const ArticlesDatabase(this.database);

  static const tableName = 'News';
  final BaseDatabase database;

  Future<ArticleEntity> saveArticle(ArticleEntity article) async {
    final articleJson = article.toJson();
    final id = await database.insert(tableName, articleJson);
    return ArticleEntity.fromJsonWithId(id, articleJson);
  }

  Future<List<ArticleEntity>> loadArticles() async {
    final rows = await database.query(tableName);
    return rows.map((json) => ArticleEntity.fromJson(json)).toList();
  }

  Future<void> close() {
    return database.close();
  }
}

ArticlesDatabase buildDefaultNewsDatabase() {
  Future<void> onDatabaseCreation(Database database, int version) async {
    await database.execute('create table ${ArticlesDatabase.tableName} ('
        'id integer primary key autoincrement, '
        'sourceId text, '
        'sourceName text not null, '
        'author text, '
        'title text not null, '
        'description text, '
        'content text, '
        'publishedAt text not null, '
        'saved integer not null'
        ')');
  }

  const databaseName = 'news_db';
  return ArticlesDatabase(BaseDatabase(databaseName, onDatabaseCreation));
}
