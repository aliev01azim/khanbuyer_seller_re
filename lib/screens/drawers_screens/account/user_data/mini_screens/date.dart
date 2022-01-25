import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/helpers/formatters/input_formatter.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class Date extends StatefulWidget {
  const Date({Key? key}) : super(key: key);

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  Map user = Hive.box('userBox').get('user', defaultValue: {});

  String data = '2000-01-01';
  @override
  void initState() {
    if (user['birth_date'] != null) {
      data = user['birth_date'];
    }
    super.initState();
  }

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
                onPressed: user['birth_date'] != data && data.isNotEmpty
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
              autofocus: true,
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
