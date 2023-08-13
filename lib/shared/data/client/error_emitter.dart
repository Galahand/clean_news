import 'dart:async';

class ErrorEmitter {
  ErrorEmitter();

  final errorStreamController = StreamController<dynamic>();

  Stream<dynamic> get errorStream => errorStreamController.stream;

  void emit(dynamic exception) {
    errorStreamController.add(exception);
  }
}
