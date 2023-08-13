import 'package:flutter/foundation.dart';

import '../model/error_response.dart';
import 'error_emitter.dart';
import 'http_provider.dart';
import 'response_decoder.dart';

bool alwaysTrue(dynamic e) => true;

class BaseClient {
  const BaseClient(
    this.domain,
    this.decoder, {
    this.defaultHeaders,
    this.http = const HttpProvider(),
    this.errorEmitter,
    this.shouldPrint = true,
  });

  final HttpProvider http;
  final String domain;
  final Map<String, String>? defaultHeaders;
  final ResponseDecoder decoder;
  final ErrorEmitter? errorEmitter;
  final bool shouldPrint;

  Future<T> get<T>({
    required String path,
    required T Function(Map<String, dynamic> map) fromJson,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? additionalHeaders,
    bool Function(dynamic error) shouldEmitGlobalError = alwaysTrue,
  }) async {
    final url = Uri.https(domain, path, queryParameters?.removeNullValues());

    printInDebug(url);

    final headers = additionalHeaders ?? {};
    headers.addAll(defaultHeaders ?? {});

    try {
      final response = await http.get(url, headers: headers);
      final json = decoder.decode(response.bodyBytes);

      if (json['status'] == 'error') {
        final errorResponse = ErrorResponse.fromJson(json);
        throw errorResponse;
      }

      printInDebug(json);

      return fromJson(json);
    } catch (e) {
      if (shouldEmitGlobalError(e)) errorEmitter?.emit(e);
      printInDebug(e);
      rethrow;
    }
  }

  void printInDebug(dynamic toPrint) {
    if (shouldPrint) return;
    if (kDebugMode) print(toPrint);
  }
}

extension on Map<String, dynamic> {
  Map<String, dynamic>? removeNullValues() {
    final result = <String, dynamic>{};
    for (var mapEntry in entries) {
      if (mapEntry.value != null) result[mapEntry.key] = mapEntry.value;
    }
    return result.isEmpty ? null : result;
  }
}
