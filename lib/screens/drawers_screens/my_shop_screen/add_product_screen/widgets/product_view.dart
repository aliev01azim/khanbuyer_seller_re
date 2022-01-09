// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/products_controller.dart';
import '../../../../../helpers/app_dialog.dart';
import 'buttons.dart';
import 'color_item.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  ProductScreen(this.product, {Key? key}) : super(key: key);
  dynamic product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _controller = Get.find<ProductsController>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = GlobalKey();

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(widget.product['title']),
        actions: [
          IconButton(
            tooltip: 'Удалить продукт',
            onPressed: () async {
              return await Get.dialog(
                AppDialog(
                  title: 'Вы уверены что хотите удалить продукт?',
                  onConfirm: () =>
                      _controller.removeProduct(widget.product['id']),
                  onCancel: () => Get.back(),
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: !widget.product.containsKey('id')
          ? const SizedBox()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ProductRow(
                    title: 'Наименование : ${widget.product['title']}',
                  ),
                  ProductRow(
                    title: 'Описание : ${widget.product['description']}',
                  ),
                  ProductRow(
                    title: 'Материал : ${widget.product['material']}',
                  ),
                  ProductRow(
                    title: 'Размеры : ${widget.product['sizesString']}',
                  ),
                  ProductRow(
                    title: 'Сезонность : ${widget.product['seasonsString']}',
                  ),
                  ProductRow(
                    title: 'Пол : ${widget.product['gendersString']}',
                  ),
                  if (widget.product['colors'].isNotEmpty) ...[
                    const ProductRow(
                      title: 'Цвета : ',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ] else ...[
                    const ProductRow(
                      title: 'Цвета : Не добавлены',
                    ),
                  ],
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.product['colors'].isEmpty
                        ? 1
                        : widget.product['colors'].length,
                    itemBuilder: (context, index) => ColorItem(
                        product: widget.product,
                        color: widget.product['colors'].isNotEmpty
                            ? widget.product['colors'][index]
                            : {}),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: SellerButtons(
        product: widget.product,
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  final String title;

  const ProductRow({
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
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.replaceAll('null', 'Не выбрано'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
