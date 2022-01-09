import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final dynamic product;

  const ProductDetails({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${product["title"]}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product['description'],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product['sizeGroupTitle'] ?? product['category']['title'],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
