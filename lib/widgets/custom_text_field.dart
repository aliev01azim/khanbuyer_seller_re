import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final dynamic validator;
  final Function? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final InputDecoration? decoration;
  final bool? obscureText;
  final FocusNode? focusNode;
  final double? marginTop;
  final bool? enabled;
  final TextStyle? style;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.decoration,
    this.focusNode,
    this.obscureText = false,
    this.marginTop = 0,
    this.enabled,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop!),
      child: TextFormField(
        obscureText: obscureText!,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: decoration,
        focusNode: focusNode,
        enabled: enabled,
        style: style,
      ),
    );
  }
}
