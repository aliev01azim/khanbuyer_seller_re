import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/favorites_controller.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';
import 'package:khanbuer_seller_re/widgets/drawer.dart';

import 'widgets/filter_modal.dart';
import 'widgets/filters.dart';
import 'widgets/products_list.dart';

class ShopsProductsScreen extends StatefulWidget {
  const ShopsProductsScreen({Key? key}) : super(key: key);

  @override
  _ShopProductsScreenState createState() => _ShopProductsScreenState();
}

class _ShopProductsScreenState extends State<ShopsProductsScreen> {
  final _shopsController = Get.find<ShopsProductsController>();

  final _favController = Get.find<FavoritesController>();
  late double _modalHeight, _statusBarHeight;

  Future<void> getData() async {
    await _shopsController.getShops();
    // await _shopsController.getCategories();
    await _shopsController.getProducts();

    if (_favController.favorites.isEmpty) {
      _favController.getFavorites();
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _shopsController.resetFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _modalHeight = MediaQuery.of(context).size.height - _statusBarHeight;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Общий каталог'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.blur_linear,
            ),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => FilterModal(_modalHeight),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: getData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            print(snapshot.data);
            return Column(
              children: const [
                Filters(),
                Expanded(
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
              ],
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
