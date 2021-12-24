import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';

import '../../add_product_screen.dart';

class SubCategories3 extends StatelessWidget {
  const SubCategories3(this.parent, this.children, {Key? key})
      : super(key: key);
  final String parent;
  final List children;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(children[index]['title']),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              onTap: () {
                Get.find<AddProductController>()
                    .addCategoryValue(children[index]);
                //Get.until((route) => Get.currentRoute == '/AddProductForm');
                Get.close(3);
              }),
        ),
      ),
    );
  }
}
