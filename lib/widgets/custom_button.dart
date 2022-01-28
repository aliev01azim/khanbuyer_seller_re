import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }
}

class IndicatorMini extends StatelessWidget {
  final Color? color;
  const IndicatorMini({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      width: 12,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}

ButtonStyle disabledStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(
    const Color(0xFFECEEEF),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),
);

class CustomButton extends StatelessWidget {
  final bool loading;
  final Widget child;
  final Function onPressed;
  final double? width;
  final double height;
  final ButtonStyle? buttonStyle;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.buttonStyle,
    this.loading = false,
    this.width,
    this.height = 48,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: disabled ? disabledStyle : buttonStyle,
        child: loading ? const Indicator() : child,
        onPressed: (disabled || loading) ? null : onPressed(),
      ),
    );
  }
}

class CustomButtonForDialog extends StatelessWidget {
  final bool loading;
  final Widget child;
  final Function onPressed;
  final double? width;
  final double height;
  final ButtonStyle? buttonStyle;
  final bool disabled;

  const CustomButtonForDialog({
    Key? key,
    required this.child,
    required this.onPressed,
    this.buttonStyle,
    this.loading = false,
    this.width,
    this.height = 48,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: disabled ? disabledStyle : buttonStyle,
        child: loading ? const Indicator() : child,
        onPressed: (disabled || loading) ? null : () => onPressed(),
      ),
    );
  }
}
