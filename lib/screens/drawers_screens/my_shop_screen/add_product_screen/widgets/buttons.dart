import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/add_product_screen/widgets/add_color_form.dart';

import 'edit_product_form.dart';

class SellerButtons extends StatelessWidget {
  final dynamic product;
  const SellerButtons({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<ProductsController>();
    bool loading = _controller.status == AddProductStatus.Loading;
    if (loading) {
      return const SizedBox();
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: const Text(
                'Редактировать',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Get.to(
                () => EditProductForm(product: product),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              child: const Text('Добавить цвет',
                  style: TextStyle(color: Colors.white)),
              onPressed: () => Get.to(
                () => AddColorForm(product),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
