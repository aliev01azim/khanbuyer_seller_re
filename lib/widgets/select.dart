// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Select extends StatefulWidget {
  final String title;
  final List options;
  final bool multi;
  final Function onChanged;
  final value;

  const Select({
    Key? key,
    required this.options,
    required this.onChanged,
    @required this.value,
    this.title = '',
    this.multi = false,
  }) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String _valuesTitle() {
    if (widget.value is List) {
      if (widget.value.length > 0) {
        List options = [...widget.options];
        options.retainWhere((element) => widget.value.contains(element['id']));
        return options.map((e) => e['title']).join(', ');
      } else {
        return 'Выбрать';
      }
    } else {
      if (widget.value != null) {
        final option = widget.options
            .singleWhere((element) => element['id'] == widget.value);
        return option['title'];
      } else {
        return 'Выбрать';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: -1,
            color: Colors.grey,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  _valuesTitle(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              onPressed: () {
                Get.dialog(
                  SelectModal(
                    options: widget.options,
                    onChanged: widget.onChanged,
                    value: widget.value,
                    multi: widget.multi,
                    title: widget.title,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SelectModal extends StatefulWidget {
  final String title;
  final List options;
  final bool multi;
  final Function onChanged;
  final value;

  const SelectModal({
    Key? key,
    required this.options,
    required this.onChanged,
    @required this.value,
    this.title = '',
    this.multi = false,
  }) : super(key: key);

  @override
  _SelectModalState createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
  List _ids = [];
  dynamic _id;

  @override
  initState() {
    if (widget.value is List) {
      _ids = widget.value;
    } else {
      _id = widget.value;
    }
    super.initState();
  }

  _checkOption(id) {
    if (widget.multi) {
      if (_ids.contains(id)) {
        setState(() {
          _ids.removeWhere((index) => index == id);
        });
      } else {
        setState(() {
          _ids.add(id);
        });
      }
      widget.onChanged(_ids);
    } else {
      dynamic _value = _id == id ? null : id;
      setState(() {
        _id = _value;
      });
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.options.length,
        itemBuilder: (_, i) {
          bool checked = false;
          final option = widget.options[i];
          if (widget.multi) {
            checked = _ids.contains(option['id']);
          } else {
            checked = _id == option['id'];
          }

          return Container(
            margin: const EdgeInsets.only(
              bottom: 5,
            ),
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  option['title'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: checked ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              onPressed: () => _checkOption(option['id']),
            ),
          );
        },
      ),
    );
  }
}
