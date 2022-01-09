import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';

import 'sub_3.dart';

class SubCategories2 extends StatelessWidget {
  SubCategories2(
      {Key? key,
      required this.data,
      required this.categories,
      required this.onChange,
      required this.onChanged})
      : super(key: key);
  final dynamic data;
  final List categories;
  final Function onChange;
  final Function onChanged;
  final _controller = Get.find<ProductsController>();
  @override
  Widget build(BuildContext context) {
    final _subCategories = _controller.categories
        .where((element) => element['parent_id'] == data['id'])
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _subCategories.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(_subCategories[index]['title']),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              onTap: () async {
                final children = _controller.categories
                    .where((element) =>
                        element['parent_id'] == _subCategories[index]['id'])
                    .toList();
                onChange(_subCategories[index]);
                if (children.isNotEmpty) {
                  await Get.to(
                    () => SubCategories3(
                        data: _subCategories[index]['title'],
                        children: children,
                        categories: categories,
                        onChange: onChange,
                        onChanged: onChanged),
                  );
                } else {
                  Get.close(2);
                }
              }),
        ),
      ),
    );
  }
}
