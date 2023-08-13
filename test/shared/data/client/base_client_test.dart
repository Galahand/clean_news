import 'dart:typed_data';

import 'package:clean_news/shared/data/client/base_client.dart';
import 'package:clean_news/shared/data/client/error_emitter.dart';
import 'package:clean_news/shared/data/client/http_provider.dart';
import 'package:clean_news/shared/data/client/response_decoder.dart';
import 'package:clean_news/shared/data/model/error_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockDecoder extends Mock implements ResponseDecoder {}

class MockHttpProvider extends Mock implements HttpProvider {}

class MockErrorEmitter extends Mock implements ErrorEmitter {}

const _testDomain = 'testDomain.com';
const _testDefaultHeaders = {'testKey': 'testValue'};

const _testErrorStatus = 'error';
const _testErrorCode = 'errorCode';
const _testErrorMessage = 'errorMessage';

const _mockErrorResponse = {
  'status': _testErrorStatus,
  'code': _testErrorCode,
  'message': _testErrorMessage,
};

void main() {
  late HttpProvider mockHttpProvider;
  late ErrorEmitter mockErrorEmitter;
  late MockDecoder mockDecoder;

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockHttpProvider = MockHttpProvider();
    mockErrorEmitter = MockErrorEmitter();
    mockDecoder = MockDecoder();
  });

  BaseClient buildTestBaseClient() {
    return BaseClient(
      _testDomain,
      mockDecoder,
      defaultHeaders: _testDefaultHeaders,
      http: mockHttpProvider,
      errorEmitter: mockErrorEmitter,
      shouldPrint: false,
    );
  }

  test('Gets successful request', () async {
    final mockSuccessResponse = http.Response("", 200);
    final mockJson = <String, dynamic>{'mockKey': 'mockValue'};

    when(() => mockHttpProvider.get(any(), headers: _testDefaultHeaders))
        .thenAnswer((_) async => mockSuccessResponse);
    when(() => mockDecoder.decode(any())).thenReturn(mockJson);

    final baseClient = buildTestBaseClient();

    final result = await baseClient.get(path: 'test', fromJson: (map) => map);
    expect(result, mockJson);
  });

  test(
    'Request with status of failure throws error',
    () async {
      final mockSuccessResponse = http.Response("", 200);

      when(() => mockHttpProvider.get(any(), headers: _testDefaultHeaders))
          .thenAnswer((_) async => mockSuccessResponse);
      when(() => mockDecoder.decode(any())).thenReturn(_mockErrorResponse);

      final baseClient = buildTestBaseClient();

      try {
        await baseClient.get(
          path: 'test',
          fromJson: (map) => map,
        );
        fail('should throw error');
      } on ErrorResponse catch (e) {
        verify(() => mockErrorEmitter.emit(e)).called(1);
        expect(e.toJson(), _mockErrorResponse);
      } catch (e) {
        fail('Error should be of type ErrorResponse');
      }
    },
  );

  test(
    'Failed request throws error',
    () async {
      final mockError = Exception();
      when(() => mockHttpProvider.get(any(), headers: _testDefaultHeaders))
          .thenAnswer((_) => Future.error(mockError));

      final baseClient = buildTestBaseClient();

      try {
        await baseClient.get(
          path: 'test',
          fromJson: (map) => map,
        );
        fail('should throw error');
      } catch (e) {
        verify(() => mockErrorEmitter.emit(e)).called(1);
        expect(e, mockError);
      }
    },
  );

  test(
    'Error is not sent globally if shouldEmitGlobalError is false',
    () async {
      final mockError = Exception();
      when(() => mockHttpProvider.get(any(), headers: _testDefaultHeaders))
          .thenAnswer((_) => Future.error(mockError));

      final baseClient = buildTestBaseClient();

      try {
        await baseClient.get(
          path: 'test',
          fromJson: (map) => map,
          shouldEmitGlobalError: (e) => false,
        );
        fail('should throw error');
      } catch (e) {
        verifyNever(() => mockErrorEmitter.emit(e));
        expect(e, mockError);
      }
    },
  );
}
