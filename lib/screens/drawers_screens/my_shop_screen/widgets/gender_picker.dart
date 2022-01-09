import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';

class GenderTile extends StatefulWidget {
  final List genders;
  final String gendersFromServer;
  final Function onChanged;

  const GenderTile({
    Key? key,
    required this.genders,
    required this.gendersFromServer,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<GenderTile> createState() => _GenderTileState();
}

class _GenderTileState extends State<GenderTile> {
  List genders = [];
  List textOfGenders = [];
  @override
  void initState() {
    genders = widget.genders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (genders.isNotEmpty) {
      genders.sort((a, b) => a['id'].compareTo(b['id']));
      textOfGenders = genders.map((e) => e['title']).toList();
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          GenderPicker(
            genders: genders,
            onChange: (value) {
              setState(() {
                if (value['isChosen']) {
                  genders.add(value);
                } else {
                  genders.remove(value);
                }
              });
            },
            onChanged: (value) => widget.onChanged(value),
          ),
        );
      },
      title: const Text(
        'Пол',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          genders.isEmpty
              ? widget.gendersFromServer.isEmpty
                  ? 'Не выбрано'
                  : widget.gendersFromServer
              : textOfGenders.join(', '),
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

class GenderPicker extends StatefulWidget {
  final List genders;
  final Function onChange;
  final Function onChanged;

  const GenderPicker({
    Key? key,
    required this.genders,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  final values = Get.find<ProductsController>().genders;
  List genders = [];
  @override
  void initState() {
    genders = widget.genders;
    values.sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(genders);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Размеры')),
      body: ListView.builder(
        itemCount: values.length,
        itemBuilder: (_, index) {
          var size = values[index];
          return CheckboxListTile(
            title: Text(size['title']),
            value: size['isChosen'] ?? false,
            onChanged: (bool? value) {
              setState(() {
                size['isChosen'] = value!;
              });

              widget.onChange(size);
            },
          );
        },
      ),
    );
  }
}
