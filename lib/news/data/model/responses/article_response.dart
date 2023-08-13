import 'package:json_annotation/json_annotation.dart';

import 'source_response.dart';

part 'article_response.g.dart';

@JsonSerializable()
class ArticleResponse {
  const ArticleResponse(
    this.source,
    this.author,
    this.title,
    this.description,
    this.content,
    this.publishedAt,
  );

  final SourceResponse source;
  final String? author;
  final String title;
  final String? description;
  final String? content;
  final String publishedAt;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}
