// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleEntity _$ArticleEntityFromJson(Map<String, dynamic> json) =>
    ArticleEntity(
      json['id'] as int?,
      json['sourceId'] as String?,
      json['sourceName'] as String,
      json['author'] as String?,
      json['title'] as String,
      json['description'] as String?,
      json['content'] as String?,
      json['publishedAt'] as String,
      savedFromJson(json['saved'] as int),
    );

Map<String, dynamic> _$ArticleEntityToJson(ArticleEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['sourceId'] = instance.sourceId;
  val['sourceName'] = instance.sourceName;
  val['author'] = instance.author;
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['content'] = instance.content;
  val['publishedAt'] = instance.publishedAt;
  val['saved'] = savedToJson(instance.saved);
  return val;
}
