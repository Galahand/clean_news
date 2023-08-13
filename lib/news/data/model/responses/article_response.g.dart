// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    ArticleResponse(
      SourceResponse.fromJson(json['source'] as Map<String, dynamic>),
      json['author'] as String?,
      json['title'] as String,
      json['description'] as String?,
      json['content'] as String?,
      json['publishedAt'] as String,
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) =>
    <String, dynamic>{
      'source': instance.source,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'publishedAt': instance.publishedAt,
    };
