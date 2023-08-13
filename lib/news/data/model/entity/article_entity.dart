import 'package:json_annotation/json_annotation.dart';

part 'article_entity.g.dart';

@JsonSerializable()
class ArticleEntity {
  const ArticleEntity(
    this.id,
    this.sourceId,
    this.sourceName,
    this.author,
    this.title,
    this.description,
    this.content,
    this.publishedAt,
    this.saved,
  );

  factory ArticleEntity.fromJson(Map<String, dynamic> json) =>
      _$ArticleEntityFromJson(json);

  factory ArticleEntity.fromJsonWithId(int id, Map<String, dynamic> json) {
    json['id'] = id;
    return ArticleEntity.fromJson(json);
  }

  @JsonKey(includeIfNull: false)
  final int? id;

  final String? sourceId;
  final String sourceName;
  final String? author;
  final String title;
  final String? description;
  final String? content;
  final String publishedAt;

  @JsonKey(fromJson: savedFromJson, toJson: savedToJson)
  final bool saved;

  Map<String, dynamic> toJson() => _$ArticleEntityToJson(this);
}

bool savedFromJson(int value) => value == 1;
int savedToJson(bool value) => value ? 1 : 0;
