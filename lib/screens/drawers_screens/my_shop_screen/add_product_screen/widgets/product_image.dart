import 'package:flutter/material.dart';
import 'package:khanbuer_seller_re/widgets/custom_image.dart';

class ProductImage extends StatelessWidget {
  final dynamic product;

  const ProductImage({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff7f7f7),
      child: CustomImage(
        url: product['colors'].isNotEmpty
            ? product['colors'][0]['pictures'][0]['picture'] ??
                product['colors'][0]['thumbnailPicture']
            : '/yii2images/images/image-by-item-and-alias?item=&dirtyAlias=placeHolder_300x.png',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
