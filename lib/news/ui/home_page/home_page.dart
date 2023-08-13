import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/home_controller.dart';
import 'home_page_content.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(
      () => HomePageContent(
        newsResult: controller.articles(),
        onTileSaveButtonPressed: controller.saveArticle,
      ),
    );
  }
}
