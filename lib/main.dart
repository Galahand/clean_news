import 'package:clean_news/news/di/home_bindings.dart';
import 'package:clean_news/shared/data/client/error_emitter.dart';
import 'package:clean_news/shared/ui/component/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'news/ui/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    setGlobalBindings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalErrorHandler(
      errorStream: Get.find<ErrorEmitter>().errorStream,
      scaffoldKey: _scaffoldKey,
      child: GetMaterialApp(
        scaffoldMessengerKey: _scaffoldKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MockHome(),
        initialBinding: HomeBindings(),
        getPages: [
          GetPage(
            name: HomePage.routeName,
            page: () => const HomePage(),
            binding: Home2Binding(),
          ),
        ],
      ),
    );
  }

  void setGlobalBindings() {
    Get.put(ErrorEmitter(), permanent: true);
  }
}

class MockHome extends StatelessWidget {
  const MockHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () => Get.toNamed(HomePage.routeName),
          child: const Text("Go to news"),
        ),
      ),
    );
  }
}
