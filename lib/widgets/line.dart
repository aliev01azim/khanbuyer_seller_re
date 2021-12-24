import 'package:flutter/material.dart';

class CustomLine extends StatelessWidget {
  const CustomLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: double.infinity,
      height: 1,
    );
  }
}
