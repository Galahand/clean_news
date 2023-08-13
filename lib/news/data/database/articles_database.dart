import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../../shared/data/database/base_database.dart';
import '../model/entity/article_entity.dart';

const _tableName = 'News';

class ArticlesDatababse {
  const ArticlesDatababse(this.database);

  final BaseDatabase database;

  Future<ArticleEntity> saveArticle(ArticleEntity article) async {
    final articleJson = article.toJson();
    final id = await database.insert(_tableName, articleJson);
    return ArticleEntity.fromJsonWithId(id, articleJson);
  }

  Future<List<ArticleEntity>> loadArticles() async {
    final rows = await database.query(_tableName);
    return rows.map((json) => ArticleEntity.fromJson(json)).toList();
  }
}

ArticlesDatababse buildDefaultNewsDatabase() {
  Future<void> onDatabaseCreation(Database database, int version) async {
    await database.execute('create table $_tableName ('
        'id integer primary key autoincrement, '
        'sourceId text, '
        'sourceName text not null, '
        'author text, '
        'title text not null, '
        'description text, '
        'content text, '
        'publishedAt text not null'
        ')');
  }

  const databaseName = 'news_db';
  return ArticlesDatababse(BaseDatabase(databaseName, onDatabaseCreation));
}
