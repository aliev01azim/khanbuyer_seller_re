import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/auth_controller.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class Gender extends StatefulWidget {
  const Gender({Key? key}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();
  Future<void> _handleRequest() async {
    if (_selectedGender == _genders[0]) {
      _selectedGender = '2';
    } else {
      _selectedGender = '1';
    }
    if (_formKey.currentState!.validate()) {
      _authController.editGender(_selectedGender!);
    }
  }

  final List<String> _genders = const ['Мужской', 'Женский'];
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пол'),
        actions: [
          GetBuilder<AuthController>(
            builder: (_) {
              final bool loading = _.userEditStatus == UserEditStatus.Loading;

              return IconButton(
                onPressed: user['gender'] != _selectedGender
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: DropdownButton(
                  hint: const Text('Выберите свой пол'),
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  },
                  items: _genders.map((location) {
                    return DropdownMenuItem(
                      child: Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
