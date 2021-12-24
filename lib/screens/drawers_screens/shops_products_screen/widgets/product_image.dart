import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:khanbuer_seller_re/widgets/custom_image.dart';

class ProductImage extends StatelessWidget {
  final dynamic product;

  const ProductImage({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xfff7f7f7),
          child: CustomImage(
            url: product['thumbnailPicture'],
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            child: const Icon(Icons.favorite_border),
            onTap: () {},
          ),
        )
      ],
    );
  }
}
