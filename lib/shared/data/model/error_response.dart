import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  const ErrorResponse(this.status, this.code, this.message);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  final String status;
  final String code;
  final String message;

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
