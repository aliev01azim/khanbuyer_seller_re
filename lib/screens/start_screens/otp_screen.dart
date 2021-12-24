import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:khanbuer_seller_re/widgets/logo.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _timer;
  int _start = 60;
  final _otp = TextEditingController();
  String _currentCode = '';
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // _listenOtp();
    _setTimer();
  }

  @override
  void deactivate() {
    if (_timer!.isActive) {
      _timer!.cancel();
    } else {
      _setTimer();
    }
    super.deactivate();
  }

  void _setTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _handleRegister() async {
    await _authController.checkConfirmationCode(_currentCode);
  }

  @override
  void dispose() {
    _timer!.cancel();
    _otp.dispose();
    super.dispose();
  }

  // void _listenOtp() async {
  //   await SmsAutoFill().listenForCode;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            const LogoWidget(),
            const SizedBox(
              height: 51,
            ),
            Text(
              'Введите последние 4 цифры',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 89,
            ),
            PinFieldAutoFill(
                decoration: const UnderlineDecoration(
                    colorBuilder: FixedColorBuilder(Colors.grey),
                    textStyle: TextStyle(color: Colors.black)),
                currentCode: _currentCode,
                autoFocus: true,
                // onCodeSubmitted: //code submitted callback
                onCodeChanged: (p0) {
                  setState(() {
                    _currentCode = p0!;
                  });
                },
                codeLength: 4),
            const SizedBox(
              height: 36,
            ),
            TextButton(
                onPressed: _start == 0 ? () => Get.back() : null,
                child: Text('Повторно запросить код ($_start)')),
            const SizedBox(
              height: 88,
            ),
            GetBuilder<AuthController>(
              builder: (_) {
                final bool loading = _.status == UserStatus.Authenticating;
                return CustomButton(
                  height: 48,
                  width: double.infinity,
                  loading: loading,
                  child: const Text("Продолжить"),
                  onPressed:
                      _currentCode.length == 4 ? () => _handleRegister : () {},
                  buttonStyle: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
