import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/helpers/cities_service.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:khanbuer_seller_re/widgets/custom_text_field.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helpers/validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TapGestureRecognizer _onPressRecognizer;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _marketFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _marketController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final _authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _cities = [];
  String _city = '';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _marketController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    _emailFocusNode.dispose();
    _countryFocusNode.dispose();
    _cityFocusNode.dispose();
    _marketFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'full_name': _fullNameController.text.trim(),
        'country': _countryController.text.trim(),
        'city': _city.trim(),
        'market': _marketController.text.trim(),
        'phone_number': _phoneNumberController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      // _authController.register(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              controller: _fullNameController,
              validator: requiredValidation,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_countryFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Ф.И.О',
              ),
            ),
            const SizedBox(height: 15),
            TypeAheadFormField(
              validator: requiredValidation,
              noItemsFoundBuilder: (_) => const ListTile(
                title: Text('Не найдено'),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: _countryFocusNode,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cityFocusNode);
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Страна',
                ),
              ),
              suggestionsCallback: (pattern) =>
                  CitiesService.getCountriesSuggestions(pattern),
              itemBuilder: (_, dynamic suggestion) => ListTile(
                title: Text(suggestion['name']),
              ),
              transitionBuilder: (_, suggestionsBox, ac) => suggestionsBox,
              onSuggestionSelected: (dynamic suggestion) {
                if (suggestion['name'] != _countryController.text) {
                  _cityController.clear();
                  _city = '';
                }
                _countryController.text = suggestion['name'];
                _cities = suggestion['cities'];
              },
            ),
            const SizedBox(height: 15),
            TypeAheadFormField(
              validator: requiredValidation,
              noItemsFoundBuilder: (_) => const ListTile(
                title: Text('Не найдено'),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: _cityFocusNode,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_marketFocusNode);
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Город',
                ),
              ),
              suggestionsCallback: (pattern) =>
                  CitiesService.getCitiesSuggestions(pattern, _cities),
              itemBuilder: (_, dynamic suggestion) => ListTile(
                title: Text(suggestion['city']),
                subtitle: Text(suggestion['region']),
              ),
              transitionBuilder: (_, suggestionsBox, ac) => suggestionsBox,
              onSuggestionSelected: (dynamic suggestion) {
                _cityController.text = suggestion['city'];
                _city = '${suggestion['region']}, ${suggestion['city']}';
              },
            ),
            CustomTextField(
              marginTop: 15,
              focusNode: _marketFocusNode,
              controller: _marketController,
              validator: requiredValidation,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Рынок/торговая точка',
              ),
            ),
            CustomTextField(
              marginTop: 15,
              focusNode: _phoneNumberFocusNode,
              controller: _phoneNumberController,
              validator: requiredValidation,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Номер телефона',
                prefixText: '+',
              ),
            ),
            CustomTextField(
              marginTop: 15,
              focusNode: _emailFocusNode,
              controller: _emailController,
              validator: () => emailValidation,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            CustomTextField(
              marginTop: 15,
              obscureText: true,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              validator: requiredValidation,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Пароль',
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context)
                    .requestFocus(_passwordConfirmationFocusNode);
              },
            ),
            CustomTextField(
              marginTop: 15,
              obscureText: true,
              controller: _passwordConfirmationController,
              focusNode: _passwordConfirmationFocusNode,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Поле необходимо заполнить';
                } else if (value != _passwordController.text) {
                  return 'Пароли не совпадают';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Подтвердите пароль',
              ),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                ),
                children: [
                  const TextSpan(text: 'Регистрируясь, Вы соглашаетесь с '),
                  TextSpan(
                    recognizer: _onPressRecognizer,
                    text: 'общими условиями ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: 'сервиса.'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GetBuilder<AuthController>(
              builder: (_) {
                final bool loading = _.status == UserStatus.Authenticating;
                return CustomButton(
                  height: 48,
                  width: double.infinity,
                  loading: loading,
                  child: const Text('Регистрация'),
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
            )
          ],
        ),
      ),
    );
  }
}
