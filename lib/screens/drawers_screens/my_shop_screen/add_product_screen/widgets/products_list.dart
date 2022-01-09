import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/products_controller.dart';
import 'product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (_) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.51,
          ),
          itemCount: _.products.length,
          itemBuilder: (BuildContext context, int index) {
            return Product(product: _.products[index]);
          },
        );
      },
    );
  }
}
