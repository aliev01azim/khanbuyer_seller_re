import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key, required this.onTap, required this.title})
      : super(key: key);
  final Function() onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      onTap: onTap,
    );
  }
}

// ignore: must_be_immutable
class CustomUserListTile extends StatelessWidget {
  CustomUserListTile(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.boxValue})
      : super(key: key);
  final Function() onTap;
  final String title;
  String boxValue;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ValueListenableBuilder(
          valueListenable: Hive.box('userBox').listenable(),
          builder: (_, Box box, __) {
            if (boxValue == 'gender') {
              return Text(
                box.get('user')[boxValue] == null
                    ? title
                    : box.get('user')[boxValue] == '2'
                        ? 'Мужской'
                        : 'Женский',
                style: const TextStyle(fontSize: 16),
              );
            } else if (boxValue == 'email') {
              return Text(
                box.get('user')[boxValue] ??
                    box.get('user')['unconfirmed_email'] ??
                    title,
                style: const TextStyle(fontSize: 16),
              );
            } else {
              return Text(
                box.get('user')[boxValue] ?? title,
                style: const TextStyle(fontSize: 16),
              );
            }
          }),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        size: 30,
      ),
      onTap: onTap,
    );
  }
}
