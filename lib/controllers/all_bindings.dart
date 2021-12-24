import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';
import 'package:khanbuer_seller_re/controllers/favorites_controller.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';
import 'package:khanbuer_seller_re/controllers/user_addresses_controller.dart';

import 'auth_controller.dart';
import 'my_shop_controller.dart';

class ShopsProductsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopsProductsController>(() => ShopsProductsController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}

class FavoritesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class AddressesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserAddressesController>(() => UserAddressesController());
  }
}

class MyShopBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyShopController>(() => MyShopController());
    Get.lazyPut<AddProductController>(() => AddProductController());
  }
}

class AddProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProductController>(() => AddProductController());
  }
}
