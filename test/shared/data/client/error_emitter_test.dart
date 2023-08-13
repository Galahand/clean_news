import 'package:clean_news/shared/data/client/error_emitter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emit emits error', () async {
    final mockError = Exception();
    final errorEmitter = ErrorEmitter();

    errorEmitter.emit(mockError);
    final error = await errorEmitter.errorStream.first;

    expect(error, mockError);
  });
}
