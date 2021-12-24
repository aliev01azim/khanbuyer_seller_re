import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:khanbuer_seller_re/widgets/logo.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/itl_phone_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phone = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TapGestureRecognizer _onPressRecognizer;
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _onPressRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  void _handlePress() {
    Get.dialog(
      Scaffold(
        appBar: AppBar(
          title: const Text('Общие условия'),
        ),
        body: const WebView(
          initialUrl: 'https://khanbuyer.prosoft.kg/site/terms',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await _authController
          .register(_phone.replaceAll(' ', '').replaceAll('+', ''));
    }
  }

  String? requiredValidation(String? value) {
    if (value!.isEmpty) {
      return 'Поле необходимо заполнить';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(children: [
              const LogoWidget(),
              const SizedBox(
                height: 51,
              ),
              Text(
                'Войти или создать аккаунт',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                height: 89,
              ),
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntlPhoneField(
                        initialCountryCode: 'KG',
                        style: const TextStyle(
                            letterSpacing: 1, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              fontSize: 24, color: Colors.transparent),
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10.0),
                        ),
                        validator: requiredValidation,
                        onChanged: (p) {
                          _phone = p.completeNumber;
                        },
                      ),
                      const SizedBox(
                        height: 88,
                      ),

                      // ElevatedButton(
                      //   onPressed: () async {
                      //     // Надо добавить в запрос:
                      //     // ExampleApp: Your code is 123456
                      //     // FA+9qCX9VSu
                      //     // final signCode = await SmsAutoFill().getAppSignature;
                      //     // print(signCode);
                      //     // await Get.to(() => const OtpScreen());
                      //     print('+996' + _phone.text.replaceAll(' ', ''));
                      //   },
                      //   child: const Text("Получить код"),
                      // ),
                      GetBuilder<AuthController>(
                        builder: (_) {
                          final bool loading =
                              _.status == UserStatus.Authenticating;
                          return CustomButton(
                            height: 48,
                            width: double.infinity,
                            loading: loading,
                            child: const Text("Получить код"),
                            onPressed: () => _handleRegister,
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

                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          children: [
                            const TextSpan(
                                text: 'Регистрируясь, Вы соглашаетесь с ',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextSpan(
                              recognizer: _onPressRecognizer,
                              text: 'общими условиями ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: 'сервиса.'),
                          ],
                        ),
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
