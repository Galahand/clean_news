import 'package:json_annotation/json_annotation.dart';

import 'article_response.dart';

part 'everything_response.g.dart';

@JsonSerializable()
class EverythingResponse {
  const EverythingResponse(this.totalResults, this.articles);

  final int totalResults;
  final List<ArticleResponse> articles;

  factory EverythingResponse.fromJson(Map<String, dynamic> json) =>
      _$EverythingResponseFromJson(json);
}