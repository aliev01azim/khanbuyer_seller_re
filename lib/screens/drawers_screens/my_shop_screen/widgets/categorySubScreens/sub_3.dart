import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategories3 extends StatelessWidget {
  const SubCategories3(
      {Key? key,
      required this.data,
      required this.children,
      required this.categories,
      required this.onChange,
      required this.onChanged})
      : super(key: key);
  final String data;
  final List children;
  final List categories;
  final Function onChange;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(children[index]['title']),
              trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              onTap: () {
                onChange(children[index]);
                onChanged(categories);
                Get.close(3);
              }),
        ),
      ),
    );
  }
}
