import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String data = user['email'] ?? user['unconfirmed_email'] ?? '';
  final _authController = Get.find<AuthController>();
  Future<void> _handleRequest() async {
    if (_formKey.currentState!.validate()) {
      _authController.editEmail(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email'),
        actions: [
          GetBuilder<AuthController>(
            builder: (_) {
              final bool loading = _.userEditStatus == UserEditStatus.Loading;

              return IconButton(
                onPressed: user['unconfirmed_email'] != data
                    ? () async => _handleRequest()
                    : null,
                icon: loading ? const IndicatorMini() : const Icon(Icons.done),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!value!.contains('@')) {
                  return 'Введите email правильно';
                }
              },
              initialValue: data,
              onChanged: (val) {
                setState(() {
                  data = val;
                });
              }),
        ),
      ),
    );
  }
}
