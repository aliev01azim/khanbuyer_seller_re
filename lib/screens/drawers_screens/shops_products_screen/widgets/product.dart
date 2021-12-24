import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';

import 'product_details.dart';
import 'product_image.dart';

class Product extends StatelessWidget {
  final dynamic product;

  const Product({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Function removeProductFromList =
        Get.find<ShopsProductsController>().removeProductFromList;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/product',
          arguments: {
            'product': product,
            'removeProductFromList': removeProductFromList,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: -1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ProductImage(product: product),
                ),
                ProductDetails(product: product),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
