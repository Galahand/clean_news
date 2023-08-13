import 'package:json_annotation/json_annotation.dart';

part 'source_response.g.dart';

@JsonSerializable()
class SourceResponse {
  const SourceResponse(this.id, this.name);

  final String? id;
  final String name;

  factory SourceResponse.fromJson(Map<String, dynamic> json) =>
      _$SourceResponseFromJson(json);
}
