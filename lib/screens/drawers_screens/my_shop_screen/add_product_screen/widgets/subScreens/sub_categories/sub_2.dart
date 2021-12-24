import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';

import 'sub_3.dart';

class SubCategories2 extends StatelessWidget {
  SubCategories2(this.parent, {Key? key}) : super(key: key);
  final dynamic parent;
  final _controller = Get.find<AddProductController>();
  @override
  Widget build(BuildContext context) {
    final _subCategories = _controller.categories
        .where((element) => element['parent_id'] == parent['id'])
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(parent['title']),
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
                _controller.addCategoryValue(_subCategories[index]);
                if (children.isNotEmpty) {
                  await Get.to(
                    () => SubCategories3(
                        _subCategories[index]['title'], children),
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
