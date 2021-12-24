import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';
import 'package:khanbuer_seller_re/helpers/constants.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _shopController = Get.find<ShopsProductsController>();
    bool isSeller = user['roles'].containsKey(Roles.seller);
    List products = [..._shopController.products];
    if (!isSeller) {
      products.retainWhere((product) => product['in_stock'] == 1);
    }
    return LazyLoadScrollView(
      onEndOfPage: () => _shopController.getProducts(loadMore: true),
      isLoading: _shopController.status == Status.Loading,
      scrollOffset: _shopController.status == Status.Error ? 0 : 100,
      child: RefreshIndicator(
        onRefresh: () => _shopController.getProducts(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Product(product: products[i]),
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.51,
              ),
            ),
            SliverToBoxAdapter(
              child: _shopController.status == Status.Loading
                  ? Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const CircularProgressIndicator(),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
