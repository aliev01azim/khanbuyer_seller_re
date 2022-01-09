import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/add_product_screen/widgets/edit_color_form.dart';

import '../../../../../helpers/app_dialog.dart';
import '../../../../../widgets/carousel.dart';
import '../../../../../widgets/custom_image.dart';

class ColorItem extends StatelessWidget {
  const ColorItem({
    Key? key,
    required this.product,
    required this.color,
  }) : super(key: key);
  final dynamic product;
  final dynamic color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (product['colors'].isNotEmpty &&
            color['pictures'][0]['id'] != null) ...[
          Carousel(product, color)
        ] else ...[
          CustomImage(
            url: product['colors'].isNotEmpty
                ? color['pictures'][0]['picture'] ?? color['thumbnailPicture']
                : '/yii2images/images/image-by-item-and-alias?item=&dirtyAlias=placeHolder.png',
            height: 300,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ],
        ColorRow(
          title: 'Цвет: ${color['title']}',
        ),
        ColorRow(
          title: 'Цена: ${color['price']}',
        ),
        ColorRow(title: 'Код продукта: ${color['item_code']}'),
        ColorRow(
          title: 'В наличии: ${color['inStockTitle']}',
        ),
        if (color.containsKey('id')) ...[
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      Get.to(() => EditColorForm(product['id'], color)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0x009f9e9e),
                        ),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'ИЗМЕНИТЬ ЦВЕТ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GetBuilder<ProductsController>(
                  builder: (_) {
                    return GestureDetector(
                      onTap: () async {
                        return await Get.dialog(
                          AppDialog(
                            title: 'Вы уверены что хотите удалить цвет?',
                            onConfirm: () =>
                                _.removeColor(product['id'], color['id']),
                            onCancel: () => Get.back(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0x009f9e9e),
                            ),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              'УДАЛИТЬ ЦВЕТ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class ColorRow extends StatelessWidget {
  final String title;

  const ColorRow({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0x009f9e9e),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title.replaceAll('null', 'Не выбрано')),
          ),
        ],
      ),
    );
  }
}
