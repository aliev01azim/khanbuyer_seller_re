import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/helpers/formatters/input_formatter.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class Date extends StatefulWidget {
  const Date({Key? key}) : super(key: key);

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  String data = user['birth_date'] ?? '2000-01-01';
  Future<void> _handleRequest() async {
    if (_formKey.currentState!.validate()) {
      _authController.editDate(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дата рождения'),
        actions: [
          GetBuilder<AuthController>(
            builder: (_) {
              final bool loading = _.userEditStatus == UserEditStatus.Loading;

              return IconButton(
                onPressed: user['birth_date'] != data
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
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                PhoneInputFormatter(),
              ],
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
