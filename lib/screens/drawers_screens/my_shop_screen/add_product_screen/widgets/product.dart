import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_details.dart';
import 'product_image.dart';
import 'product_view.dart';

class Product extends StatelessWidget {
  final dynamic product;

  const Product({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductScreen(product),
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
