import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderTile extends StatefulWidget {
  final List genders;
  final List allGenders;
  final Function onChanged;

  const GenderTile({
    Key? key,
    required this.genders,
    required this.allGenders,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<GenderTile> createState() => _GenderTileState();
}

class _GenderTileState extends State<GenderTile> {
  List _genders = [];
  late String textOfGenders;
  @override
  void initState() {
    _genders = widget.genders;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_genders.isNotEmpty) {
      _genders.sort((a, b) => a['id'].compareTo(b['id']));
      textOfGenders = _genders.map((e) => e['title']).join(', ');
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          GenderPicker(
            genders: _genders,
            allGenders: widget.allGenders,
            onChange: (List value) {
              if (mounted) {
                setState(() {
                  _genders = value;
                });
              }
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
          _genders.isNotEmpty ? textOfGenders : 'Не выбрано',
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
  final List allGenders;
  final Function onChange;
  final Function onChanged;

  const GenderPicker({
    Key? key,
    required this.genders,
    required this.allGenders,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  List _genders = [];
  @override
  void initState() {
    for (var element in widget.genders) {
      element.addAll({'isChosen': true});
    }
    _genders = widget.genders;
    for (var _s in widget.allGenders) {
      if (_genders.any((element) => element['id'] == _s['id'])) {
        _s.addAll({'isChosen': true});
      } else {
        _s.addAll({'isChosen': false});
      }
    }
    widget.allGenders.sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(_genders);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Размеры')),
      body: ListView.builder(
        itemCount: widget.allGenders.length,
        itemBuilder: (_, index) {
          var gender = widget.allGenders[index];
          return CheckboxListTile(
            title: Text(gender['title']),
            value: gender['isChosen'],
            onChanged: (bool? value) {
              setState(() {
                gender['isChosen'] = value;
                if (gender['isChosen']) {
                  _genders.add(gender);
                } else {
                  _genders
                      .removeWhere((element) => element['id'] == gender['id']);
                }
              });
              widget.onChange(_genders);
            },
          );
        },
      ),
    );
  }
}
