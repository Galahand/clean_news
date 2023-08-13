import 'package:flutter/material.dart';

import '../model/article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    Key? key,
    required this.article,
    required this.onSaveButtonPressed,
  }) : super(key: key);

  final Article article;
  final VoidCallback onSaveButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${article.author ?? 'Anonymous'} | ${article.date}"),
        const SizedBox(height: 12),
        Text(article.title),
        const SizedBox(height: 12),
        if (article.description != null) ...[
          Text(article.description!),
          const SizedBox(height: 12),
        ],
        if (article.content != null) ...[
          Text(article.content!),
          const SizedBox(height: 12),
        ],
        SaveButton(liked: article.liked, onPressed: onSaveButtonPressed),
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.liked,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool liked;

  @override
  Widget build(BuildContext context) {
    final color = liked ? Colors.red : Colors.black;
    final icon = liked ? Icons.favorite : Icons.heart_broken_outlined;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
    );
  }
}
