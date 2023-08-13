// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'everything_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EverythingResponse _$EverythingResponseFromJson(Map<String, dynamic> json) =>
    EverythingResponse(
      json['totalResults'] as int,
      (json['articles'] as List<dynamic>)
          .map((e) => ArticleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EverythingResponseToJson(EverythingResponse instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'articles': instance.articles,
    };
