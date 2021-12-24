// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final String title;
  final List options;
  final bool multi;
  final Function onChanged;
  final value;

  const Options({
    Key? key,
    required this.options,
    required this.onChanged,
    @required this.value,
    this.title = '',
    this.multi = false,
  }) : super(key: key);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  List _ids = [];

  @override
  initState() {
    if (widget.value is List) {
      _ids = widget.value;
    }
    super.initState();
  }

  _checkOption(id) {
    if (widget.multi) {
      if (_ids.contains(id)) {
        _ids.removeWhere((index) => index == id);
      } else {
        _ids.add(id);
      }
      widget.onChanged(_ids);
    } else {
      dynamic _value = id;
      if (widget.value == _value) {
        _value = null;
      }
      widget.onChanged(_value);
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
      decoration: BoxDecoration(
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.options.map((option) {
              bool checked = false;
              if (widget.multi) {
                checked = widget.value.contains(option['id']);
              } else {
                checked = widget.value == option['id'];
              }
              return OutlinedButton(
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
                child: Text(
                  option['title'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: checked ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                onPressed: () => _checkOption(option['id']),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
