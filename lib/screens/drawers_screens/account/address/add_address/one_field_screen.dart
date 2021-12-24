import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OneFieldScreen extends StatelessWidget {
  OneFieldScreen(this.title, this.setValue, {Key? key}) : super(key: key);
  final String title;
  final Function(String) setValue;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () {
                setValue(controller.text);
                Get.back();
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3))),
            controller: controller,
            autofocus: true,
          ),
        ],
      ),
    );
  }
}
