import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeTile extends StatefulWidget {
  final List sizes;
  final List allSizes;
  final Function onChanged;

  const SizeTile({
    Key? key,
    required this.sizes,
    required this.allSizes,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SizeTile> createState() => _SizeTileState();
}

class _SizeTileState extends State<SizeTile> {
  List _sizes = [];
  late String _textOfSizes;
  @override
  void initState() {
    _sizes = widget.sizes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_sizes.isNotEmpty) {
      _sizes.sort((a, b) => a['id'].compareTo(b['id']));
      _textOfSizes = _sizes.map((e) => e['title']).join(', ');
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          SizePicker(
            sizes: _sizes,
            allSizes: widget.allSizes,
            onChange: (value) {
              if (mounted) {
                setState(() {
                  _sizes = value;
                });
              }
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
          _sizes.isNotEmpty ? _textOfSizes : 'Не выбрано',
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
  final List allSizes;
  final Function onChange;
  final Function onChanged;
  const SizePicker({
    Key? key,
    required this.sizes,
    required this.allSizes,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SizePickerState createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  List _sizes = [];
  @override
  void initState() {
    for (var element in widget.sizes) {
      element.addAll({'isChosen': true});
    }
    _sizes = widget.sizes;
    for (var _s in widget.allSizes) {
      if (_sizes.any((element) => element['id'] == _s['id'])) {
        _s.addAll({'isChosen': true});
      } else {
        _s.addAll({'isChosen': false});
      }
    }
    widget.allSizes.sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(_sizes);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Размеры')),
      body: ListView.builder(
        itemCount: widget.allSizes.length,
        itemBuilder: (_, index) {
          var size = widget.allSizes[index];
          return CheckboxListTile(
            title: Text(size['title']),
            value: size['isChosen'],
            onChanged: (bool? value) {
              setState(() {
                size['isChosen'] = value;
                if (size['isChosen']) {
                  _sizes.add(size);
                } else {
                  _sizes.removeWhere((element) => element['id'] == size['id']);
                }
              });

              widget.onChange(_sizes);
            },
          );
        },
      ),
    );
  }
}
