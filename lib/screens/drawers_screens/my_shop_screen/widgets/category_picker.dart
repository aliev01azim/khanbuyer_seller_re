import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';

import 'categorySubScreens/sub_2.dart';

class CategoryTile extends StatefulWidget {
  final List categories;
  final List<String> categoryTitles;
  final Function onChanged;

  const CategoryTile({
    Key? key,
    required this.categories,
    required this.categoryTitles,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  List categories = [];
  List<String> categoryTitles = [];
  String textOfCategories = '';
  void clearCategories() {
    categories.clear();
    categoryTitles.clear();
  }

  @override
  void initState() {
    categories = widget.categories;
    categoryTitles = widget.categoryTitles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isNotEmpty) {
      textOfCategories = categoryTitles.join(' - ');
    } else {
      textOfCategories = 'Не выбрано';
    }
    return ListTile(
      onTap: () => Get.to(
        CategoryPicker(
          categories: categories,
          onChange: (value) {
            setState(() {
              categories.add(value);
              categoryTitles.add(value['title']);
            });
          },
          onChanged: (value) => widget.onChanged(value),
          clearCategories: clearCategories,
        ),
      ),
      title: const Text(
        'Категория',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      contentPadding: const EdgeInsets.only(right: 0),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          textOfCategories,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryPicker extends StatelessWidget {
  final List categories;
  final Function onChange;
  final Function onChanged;
  final Function clearCategories;

  CategoryPicker({
    Key? key,
    required this.categories,
    required this.onChange,
    required this.onChanged,
    required this.clearCategories,
  }) : super(key: key);

  final _parentCategories = Get.find<ProductsController>()
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
                Get.to(() => SubCategories2(
                      data: _parentCategories[index],
                      categories: categories,
                      onChange: onChange,
                      onChanged: onChanged,
                    ));
                clearCategories();
                onChange(_parentCategories[index]);
              }),
        ),
      ),
    );
  }
}
