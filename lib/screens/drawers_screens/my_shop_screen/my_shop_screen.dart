import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';
import 'package:khanbuer_seller_re/controllers/all_bindings.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';

import 'add_product_screen/widgets/add_product_screen.dart';
import 'edit_shop_screen/edit_shop_screen.dart';

class MyShopScreen extends StatelessWidget {
  MyShopScreen({Key? key}) : super(key: key);

  final _controller = Get.find<AddProductController>();

  Future<void> loadData({bool reload = false}) async {
    // if (reload || _controller.shops.isEmpty) {
    //   await _controller.getSellerShops();
    // }
    if (reload || _controller.categories.isEmpty) {
      await _controller.getCategories();
    }
    // if (reload || _controller.colors.isEmpty) {
    //   await _controller.getColors();
    // }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = GlobalKey();
    print(Get.arguments?['product']['description']);
    return Scaffold(
      drawer: const AppDrawer(),
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Мой магазин'),
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
                    Card(
                      child: ValueListenableBuilder(
                          valueListenable: Hive.box('userBox').listenable(),
                          builder: (_, Box box, __) {
                            return ListTile(
                              onTap: () => Get.to(() => const EditShopScreen(),
                                  binding: MyShopBinding()),
                              title: Text(box.get('user')['shop']['title'] ??
                                  'Название магазина'),
                              subtitle: Text(box.get('user')['shop']
                                      ['description'] ??
                                  'Описание магазина'),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (Get.arguments != null)
                      Text(Get.arguments['product']['description']),
                    TextButton(
                      onPressed: () => Get.to(() => const AddProductScreen(),
                          binding: AddProductBinding()),
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
}
