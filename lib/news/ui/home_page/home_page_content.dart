import 'package:flutter/material.dart';

import '../../../shared/data/model/result.dart';
import '../articles/component/article_tile.dart';
import '../articles/model/article.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    Key? key,
    required this.newsResult,
    required this.onTileSaveButtonPressed,
  }) : super(key: key);

  final Result<List<Article>> newsResult;
  final void Function(int index) onTileSaveButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: newsResult.when(
          (news) => ListView.separated(
            itemBuilder: (_, index) {
              return ArticleTile(
                article: news[index],
                onSaveButtonPressed: () => onTileSaveButtonPressed(index),
              );
            },
            separatorBuilder: (_, index) {
              return const Divider();
            },
            itemCount: news.length,
            padding: const EdgeInsets.all(24),
          ),
          (error) => const SizedBox.shrink(),
          () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
