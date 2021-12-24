import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:khanbuer_seller_re/controllers/user_addresses_controller.dart';
import 'package:khanbuer_seller_re/helpers/cities_service.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:khanbuer_seller_re/widgets/custom_text_field.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _marketFocusNode = FocusNode();
  final FocusNode _postCodeFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _marketController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _cities = [];
  String _city = '';

  @override
  void initState() {
    final user = Get.find<UserAddressesController>().user;
    _fullNameController.value = TextEditingValue(text: user['full_name'] ?? '');
    _countryController.value = TextEditingValue(text: user['country'] ?? '');
    _cityController.value = TextEditingValue(text: user['city'] ?? '');
    _marketController.value = TextEditingValue(text: user['market'] ?? '');
    _postCodeController.value = TextEditingValue(text: user['postcode'] ?? '');
    _phoneNumberController.value =
        TextEditingValue(text: user['phone_number'] ?? '996551122001');
    _city = user['city'] ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _marketController.dispose();
    _postCodeController.dispose();
    _phoneNumberController.dispose();

    _countryFocusNode.dispose();
    _cityFocusNode.dispose();
    _marketFocusNode.dispose();
    _postCodeFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    super.dispose();
  }

  String isDefaultAddress = '0';
  void setDefaultValue(bool value) {
    setState(() {
      if (value) {
        isDefaultAddress = '1';
      } else {
        isDefaultAddress = '0';
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'recipient': _fullNameController.text.trim(),
        'country': _countryController.text.trim(),
        'city': _city.trim(),
        'full_address': _marketController.text.trim(),
        'phone_number': _phoneNumberController.text.trim(),
        'postcode': _postCodeController.text.trim(),
        'is_default': isDefaultAddress,
      };
      Get.find<UserAddressesController>().addAddress(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isSeller = user['roles'].containsKey(Roles.seller);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заполните форму'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
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
                  labelText: 'ФИО',
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
                itemBuilder: (_, Map? suggestion) => ListTile(
                  title: Text(suggestion!['name']),
                ),
                transitionBuilder: (_, suggestionsBox, ac) => suggestionsBox,
                onSuggestionSelected: (Map? suggestion) {
                  if (suggestion!['name'] != _countryController.text) {
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
              // isSeller
              // ? Container():
              CustomTextField(
                marginTop: 15,
                focusNode: _marketFocusNode,
                controller: _marketController,
                validator: requiredValidation,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_postCodeFocusNode);
                },
                decoration: const InputDecoration(
                  labelText: 'Рынок/торговая точка',
                ),
              ),
              CustomTextField(
                marginTop: 15,
                focusNode: _postCodeFocusNode,
                controller: _postCodeController,
                validator: requiredValidation,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                },
                decoration: const InputDecoration(
                  labelText: 'Почтовый индекс',
                ),
              ),

              CustomTextField(
                marginTop: 15,
                focusNode: _phoneNumberFocusNode,
                controller: _phoneNumberController,
                validator: requiredValidation,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  prefixText: '+',
                ),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: const Text(
                  'Адрес по умолчанию',
                ),
                onChanged: (bool value) => setDefaultValue(value),
                value: isDefaultAddress == '0' ? false : true,
              ),

              const SizedBox(height: 30),
              GetBuilder<UserAddressesController>(
                builder: (_) {
                  final bool loading =
                      _.addressEditStatus == AddressEditStatus.Loading;
                  return CustomButton(
                    loading: loading,
                    width: double.infinity,
                    onPressed: () => _handleSubmit,
                    child: const Text('Добавить'),
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
            ],
          ),
        ),
      ),
    );
  }
}
