// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/products_controller.dart';
import '../../../../../helpers/app_dialog.dart';
import '../../../../../widgets/carousel.dart';
import '../../../../../widgets/custom_image.dart';
import 'buttons.dart';
import 'edit_color_form.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  ProductScreen(this.product, {Key? key}) : super(key: key);
  dynamic product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _controller = Get.find<ProductsController>();
  int index = 0;
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
                  if (widget.product['colors'].isNotEmpty &&
                      widget.product['colors'][index]['pictures'][0]['id'] !=
                          null) ...[
                    Carousel(
                      product: widget.product,
                      color: widget.product['colors'][index],
                      setstate: () => setState(() {}),
                    )
                  ] else ...[
                    CustomImage(
                      url: widget.product['colors'].isNotEmpty
                          ? widget.product['colors'][index]['pictures'][0]
                                  ['picture'] ??
                              widget.product['colors'][index]
                                  ['thumbnailPicture']
                          : '/yii2images/images/image-by-item-and-alias?item=&dirtyAlias=placeHolder.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ],
                  if (widget.product['colors'].isNotEmpty)
                    ProductRow(
                      title: '${widget.product['colors'][index]['price']} руб',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  if (widget.product['colors'].isNotEmpty)
                    ProductRow(
                      title:
                          'Цвет : ${widget.product['colors'][index]['title']}',
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: buildImagesRow(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                  if (widget.product['colors'].isNotEmpty)
                    ProductRow(
                        title:
                            'Код продукта: ${widget.product['colors'][index]['item_code']}'),
                  if (widget.product['colors'].isNotEmpty)
                    ProductRow(
                      title:
                          'В наличии: ${widget.product['colors'][index]['inStockTitle']}',
                    ),
                  if (widget.product['colors'].isNotEmpty &&
                      widget.product['colors'][index].containsKey('id')) ...[
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(() => EditColorForm(
                                widget.product['id'],
                                widget.product['colors'][index])),
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
                                      title:
                                          'Вы уверены что хотите удалить цвет?',
                                      onConfirm: () => _.removeColor(
                                          widget.product['id'],
                                          widget.product['colors'][index]
                                              ['id']),
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
              ),
            ),
      bottomNavigationBar: SellerButtons(
        product: widget.product,
      ),
    );
  }

  List<Widget> buildImagesRow() {
    List<Widget> _images = [];
    for (var element in (widget.product['colors'] as List)) {
      var _ind = (widget.product['colors'] as List).indexOf(element);
      _images.add(
        GestureDetector(
          onTap: () {
            setState(() {
              index = _ind;
            });
          },
          child: Container(
            decoration: index == _ind
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
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
                child: CustomImage(
                  url: element['pictures'][0]['picture'],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return _images;
  }
}

class ProductRow extends StatelessWidget {
  final String title;
  final TextStyle style;
  const ProductRow({
    Key? key,
    required this.title,
    this.style = const TextStyle(color: Colors.black),
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
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
