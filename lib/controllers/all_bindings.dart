import 'package:get/get.dart';

import 'auth_controller.dart';

// class ShopsProductsBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ShopsProductsController>(() => ShopsProductsController());
//     // Get.lazyPut<FavoritesController>(() => FavoritesController());
//   }
// }

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
