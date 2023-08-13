import 'dart:async';

import 'package:clean_news/shared/ui/component/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows snackbar on error', (tester) async {
    final testErrorStreamController = StreamController<dynamic>();
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    await tester.pumpWidget(GlobalErrorHandler(
      errorStream: testErrorStreamController.stream,
      scaffoldKey: scaffoldKey,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldKey,
        home: const Scaffold(),
      ),
    ));

    testErrorStreamController.add(Exception());

    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('cancels subscription on dispose', (tester) async {
    final testErrorStreamController = StreamController<dynamic>();
    final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    await tester.pumpWidget(GlobalErrorHandler(
      errorStream: testErrorStreamController.stream,
      scaffoldKey: scaffoldKey,
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldKey,
        home: const Scaffold(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(testErrorStreamController.hasListener, isTrue);

    await tester.pumpWidget(Container());

    expect(testErrorStreamController.hasListener, isFalse);
  });
}
