import 'dart:async';

import 'package:flutter/material.dart';

class GlobalErrorHandler extends StatefulWidget {
  const GlobalErrorHandler({
    Key? key,
    required this.child,
    required this.errorStream,
    required this.scaffoldKey,
  }) : super(key: key);

  final Stream<dynamic> errorStream;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final Widget child;

  @override
  State<GlobalErrorHandler> createState() => _GlobalErrorHandlerState();
}

class _GlobalErrorHandlerState extends State<GlobalErrorHandler> {
  StreamSubscription<dynamic>? errorStreamSubscription;

  @override
  void initState() {
    errorStreamSubscription = widget.errorStream.listen(handleError);
    super.initState();
  }

  @override
  void dispose() {
    errorStreamSubscription?.cancel();
    super.dispose();
  }

  void handleError(dynamic error) {
    widget.scaffoldKey.currentState?.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Something went wrong',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
