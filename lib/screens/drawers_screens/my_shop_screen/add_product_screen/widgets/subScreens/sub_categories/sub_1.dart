import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/add_product_screen/widgets/subScreens/sub_categories/sub_2.dart';

class SubCategories1 extends StatelessWidget {
  SubCategories1({Key? key}) : super(key: key);
  final _parentCategories = Get.find<AddProductController>()
      .categories
      .where((element) => element['parent_id'] == null)
      .toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категория'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _parentCategories.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(_parentCategories[index]['title']),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              onTap: () {
                Get.to(() => SubCategories2(_parentCategories[index]));
                Get.find<AddProductController>()
                    .addCategoryValue(_parentCategories[index], clear: true);
              }),
        ),
      ),
    );
  }
}
