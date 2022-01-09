import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeTile extends StatefulWidget {
  final List sizes;
  final String sizesFromServer;
  final dynamic product;
  final Function onChanged;

  const SizeTile({
    Key? key,
    required this.sizes,
    required this.sizesFromServer,
    required this.product,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SizeTile> createState() => _SizeTileState();
}

class _SizeTileState extends State<SizeTile> {
  List sizes = [];
  List textOfSizes = [];
  @override
  void initState() {
    sizes = widget.sizes;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (sizes.isNotEmpty) {
      sizes.sort((a, b) => a['id'].compareTo(b['id']));
      textOfSizes = sizes.map((e) => e['title']).toList();
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          SizePicker(
            sizes: sizes,
            product: widget.product,
            onChange: (value) {
              setState(() {
                if (value['isChosen']) {
                  sizes.add(value);
                } else {
                  sizes.remove(value);
                }
              });
            },
            onChanged: (value) => widget.onChanged(value),
          ),
        );
      },
      title: const Text(
        'Размеры',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          sizes.isEmpty
              ? widget.sizesFromServer.isEmpty
                  ? 'Не выбрано'
                  : widget.sizesFromServer
              : textOfSizes.join(', '),
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

class SizePicker extends StatefulWidget {
  final List sizes;
  final Function onChange;
  final Function onChanged;
  final dynamic product;
  const SizePicker({
    Key? key,
    required this.sizes,
    required this.onChange,
    required this.product,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SizePickerState createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  List sizes = [];
  @override
  void initState() {
    sizes = widget.sizes;
    (widget.product['category']['sizeTypes'][0]['sizes'] as List)
        .sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(sizes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Размеры')),
      body: ListView.builder(
        itemCount: widget.product['category']['sizeTypes'][0]['sizes'].length,
        itemBuilder: (_, index) {
          var size = widget.product['category']['sizeTypes'][0]['sizes'][index];
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
