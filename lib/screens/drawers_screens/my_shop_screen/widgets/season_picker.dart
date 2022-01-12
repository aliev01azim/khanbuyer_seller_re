import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeasonTile extends StatefulWidget {
  final List seasons;
  final List allSeasons;
  final Function onChanged;

  const SeasonTile({
    Key? key,
    required this.seasons,
    required this.allSeasons,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SeasonTile> createState() => _SeasonTileState();
}

class _SeasonTileState extends State<SeasonTile> {
  List _seasons = [];
  late String textOfSeasons;
  @override
  void initState() {
    _seasons = widget.seasons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_seasons.isNotEmpty) {
      _seasons.sort((a, b) => a['id'].compareTo(b['id']));
      textOfSeasons = _seasons.map((e) => e['title']).join(', ');
    }
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Get.dialog(
          SeasonPicker(
            seasons: _seasons,
            allSeasons: widget.allSeasons,
            onChange: (List value) {
              if (mounted) {
                setState(() {
                  _seasons = value;
                });
              }
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
          _seasons.isNotEmpty ? textOfSeasons : 'Не выбрано',
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
  final List allSeasons;
  const SeasonPicker({
    Key? key,
    required this.seasons,
    required this.allSeasons,
    required this.onChange,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SeasonPickerState createState() => _SeasonPickerState();
}

class _SeasonPickerState extends State<SeasonPicker> {
  List _seasons = [];
  @override
  void initState() {
    for (var element in widget.seasons) {
      element.addAll({'isChosen': true});
    }
    _seasons = widget.seasons;
    for (var _s in widget.allSeasons) {
      if (_seasons.any((element) => element['id'] == _s['id'])) {
        _s.addAll({'isChosen': true});
      } else {
        _s.addAll({'isChosen': false});
      }
    }
    widget.allSeasons.sort((a, b) => a['id'].compareTo(b['id']));
    super.initState();
  }

  @override
  void dispose() {
    widget.onChanged(_seasons);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сезоны')),
      body: ListView.builder(
        itemCount: widget.allSeasons.length,
        itemBuilder: (_, index) {
          var season = widget.allSeasons[index];
          return CheckboxListTile(
            title: Text(season['title']),
            value: season['isChosen'],
            onChanged: (bool? value) {
              setState(() {
                season['isChosen'] = value;
                if (season['isChosen']) {
                  _seasons.add(season);
                } else {
                  _seasons
                      .removeWhere((element) => element['id'] == season['id']);
                }
              });

              widget.onChange(_seasons);
            },
          );
        },
      ),
    );
  }
}
