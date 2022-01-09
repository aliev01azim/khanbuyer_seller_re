import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/controllers/all_bindings.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';

import 'add_product_screen/add_product_screen.dart';
import 'add_product_screen/widgets/products_list.dart';
import 'shop/edit_shop_screen.dart';

class MyShopScreen extends StatelessWidget {
  MyShopScreen({Key? key}) : super(key: key);

  final _controller = Get.find<ProductsController>();

  Future<void> loadData({bool reload = false}) async {
    if (reload || _controller.products.isEmpty) {
      await _controller.getSellerProducts();
    }
    if (reload || _controller.categories.isEmpty) {
      await _controller.getCategories();
    }
    if (reload || _controller.genders.isEmpty) {
      await _controller.getGenders();
    }
    if (reload || _controller.seasons.isEmpty) {
      await _controller.getSeasons();
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = GlobalKey();
    return Scaffold(
      drawer: const AppDrawer(),
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Мой магазин'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            return RefreshIndicator(
              onRefresh: () => loadData(reload: true),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    shop(),
                    const Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          left: 5,
                          right: 5,
                        ),
                        child: ProductsList(),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const AddProductScreen()),
                      child: const Text('Добавить товар'),
                    )
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget shop() {
    return Card(
      child: ValueListenableBuilder(
          valueListenable: Hive.box('userBox').listenable(),
          builder: (_, Box box, __) {
            return ListTile(
              onTap: () => Get.to(() => const EditShopScreen(),
                  binding: ProductsBinding()),
              title:
                  Text(box.get('user')['shop']['title'] ?? 'Название магазина'),
              subtitle: Text(box.get('user')['shop']['description'] ??
                  'Описание магазина'),
            );
          }),
    );
  }
}
