import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';

class SizeTile extends StatefulWidget {
  final Map size;
  final Function onChanged;

  const SizeTile({
    Key? key,
    required this.size,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SizeTileState createState() => _SizeTileState();
}

class _SizeTileState extends State<SizeTile> {
  Map _size = {};

  @override
  void initState() {
    _size = widget.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic value = 'Выбрать';

    if (_size['min'] != '' && _size['max'] != '') {
      value = '${_size['min']}—${_size['max']}';
    }

    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          SizePicker(
            size: _size,
            onChange: (value) {
              setState(() {
                _size = value;
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
          value,
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
  final Map size;
  final Function onChange;
  final Function onChanged;

  const SizePicker({
    Key? key,
    required this.size,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SizePickerState createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  final TextEditingController _minSizeController = TextEditingController();
  final TextEditingController _maxSizeController = TextEditingController();

  @override
  void initState() {
    _minSizeController.value = TextEditingValue(text: widget.size['min']);
    _maxSizeController.value = TextEditingValue(text: widget.size['max']);
    super.initState();
  }

  @override
  void dispose() {
    _minSizeController.dispose();
    _maxSizeController.dispose();
    Map size = {
      'min': _minSizeController.text,
      'max': _maxSizeController.text,
    };
    widget.onChanged(size);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Размеры'),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 10,
          left: 8,
          right: 8,
        ),
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Мин. размер',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _minSizeController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.hint),
                ),
              ),
              onChanged: (value) {
                Map size = {
                  'min': value,
                  'max': _maxSizeController.text,
                };
                widget.onChange(size);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Макс. размер',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _maxSizeController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.hint),
                ),
              ),
              onChanged: (value) {
                Map size = {
                  'min': _minSizeController.text,
                  'max': value,
                };
                widget.onChange(size);
              },
            ),
          ],
        ),
      ),
    );
  }
}
