import 'package:flutter/material.dart';

import 'item.dart';

class ProductsList extends StatelessWidget {
  final List products;

  const ProductsList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (_, int index) {
        return Item(products[index]);
      },
    );
  }
}
