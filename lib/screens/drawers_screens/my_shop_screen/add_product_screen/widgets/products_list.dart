import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../../controllers/products_controller.dart';
import 'product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (_) {
        return LazyLoadScrollView(
          onEndOfPage: () => _.getSellerProducts(loadMore: true),
          isLoading: _.status == AddProductStatus.Loading,
          scrollOffset: _.status == AddProductStatus.Error ? 0 : 100,
          child: RefreshIndicator(
            onRefresh: () => _.getSellerProducts(),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (__, i) => Product(product: _.products[i]),
                    childCount: _.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.51,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _.status == AddProductStatus.Loading
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
        // return GridView.builder(
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     childAspectRatio: 0.51,
        //   ),
        //   itemCount: _.products.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Product(product: _.products[index]);
        //   },
        // );
      },
    );
  }
}
