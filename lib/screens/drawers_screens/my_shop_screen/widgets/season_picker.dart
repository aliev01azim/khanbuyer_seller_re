import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';

class SeasonTile extends StatefulWidget {
  final List seasons;
  final String seasonsFromServer;
  final Function onChanged;

  const SeasonTile({
    Key? key,
    required this.seasons,
    required this.seasonsFromServer,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SeasonTile> createState() => _SeasonTileState();
}

class _SeasonTileState extends State<SeasonTile> {
  List seasons = [];
  List textOfSeasons = [];
  @override
  void initState() {
    seasons = widget.seasons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (seasons.isNotEmpty) {
      seasons.sort((a, b) => a['id'].compareTo(b['id']));
      textOfSeasons = seasons.map((e) => e['title']).toList();
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          SeasonPicker(
            seasons: seasons,
            onChange: (value) {
              setState(() {
                if (value['isChosen']) {
                  seasons.add(value);
                } else {
                  seasons.remove(value);
                }
              });
            },
            onChanged: (value) => widget.onChanged(value),
          ),
        );
      },
      title: const Text(
        'Сезонность',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          seasons.isEmpty
              ? widget.seasonsFromServer.isEmpty
                  ? 'Не выбрано'
                  : widget.seasonsFromServer
              : textOfSeasons.join(', '),
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

class SeasonPicker extends StatefulWidget {
  final List seasons;
  final Function onChange;
  final Function onChanged;

  const SeasonPicker({
    Key? key,
    required this.seasons,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SeasonPickerState createState() => _SeasonPickerState();
}

class _SeasonPickerState extends State<SeasonPicker> {
  final values = Get.find<ProductsController>().seasons;
  List seasons = [];
  @override
  void initState() {
    seasons = widget.seasons;
    values.sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(seasons);
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
