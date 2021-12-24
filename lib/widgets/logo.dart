import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      height: 60,
      child: Center(
          child: Text(
        'KhanBuyer',
        style: TextStyle(fontSize: 25),
      )),
    );
  }
}
