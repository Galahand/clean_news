import 'dart:async';

import 'package:clean_news/news/data/repository/articles_repository.dart';
import 'package:get/get.dart';

import '../../../../shared/data/model/result.dart';
import '../../../data/model/entity/article_entity.dart';
import '../model/article.dart';

class HomeController extends GetxController {
  HomeController(this.repository);

  static const refreshDuration = Duration(seconds: 30);

  final ArticlesRepository repository;
  final articles = const Result<List<Article>>.loading().obs;
  late final Timer refreshTimer;
  late StreamSubscription subscription;

  @override
  void onInit() {
    super.onInit();
    subscription = repository.headlinesStream.map(entityToUi).listen(
      onArticlesRefreshed,
      onError: (e) {
        if (articles().loading) articles(Result.error(e));
      },
      cancelOnError: false,
    );

    repository.refreshArticleHeaders();
    refreshTimer = Timer.periodic(
      refreshDuration,
      (_) => repository.refreshArticleHeaders(),
    );
  }

  @override
  void onClose() {
    articles.close();
    refreshTimer.cancel();
    subscription.cancel();
    super.onClose();
  }

  List<Article> entityToUi(List<ArticleEntity> entities) {
    return entities.map((e) => e.toUi()).toList();
  }

  void onArticlesRefreshed(List<Article> entities) {
    articles(Result.success(entities));
  }

  Future<void> saveArticle(int index) {
    return repository.saveArticle(index);
  }
}

extension on ArticleEntity {
  Article toUi() {
    return Article(author, title, description, content, publishedAt, saved);
  }
}
