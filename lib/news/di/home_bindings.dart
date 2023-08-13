import 'package:get/get.dart';

import '../../shared/data/client/error_emitter.dart';
import '../data/client/articles_api.dart';
import '../data/database/articles_database.dart';
import '../data/repository/articles_repository.dart';
import '../ui/home_page/controller/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {}
}

class Home2Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(buildDefaultNewsApi(Get.find<ErrorEmitter>()));
    Get.put(buildDefaultNewsDatabase());

    Get.put(ArticlesRepository(Get.find(), Get.find()));
    Get.put(HomeController(Get.find()));
  }
}
