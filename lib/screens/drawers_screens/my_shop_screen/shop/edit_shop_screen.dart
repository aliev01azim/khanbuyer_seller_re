import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';

class EditShopScreen extends StatefulWidget {
  const EditShopScreen({Key? key}) : super(key: key);

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _descriptionFocusNode = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Map user = Hive.box('userBox').get('user', defaultValue: {});

  bool isNotEdited = true;
  @override
  void initState() {
    _titleController.value =
        TextEditingValue(text: user['shop']['title'] ?? '');
    _descriptionController.value =
        TextEditingValue(text: user['shop']['description'] ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
      };
      Get.find<ProductsController>().editShop(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить магазин'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                validator: requiredValidation,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                decoration: const InputDecoration(
                  labelText: 'Название магазина',
                ),
                onChanged: (String val) {
                  setState(() {
                    if (val != user['shop']['title'] && val.isNotEmpty) {
                      isNotEdited = false;
                    } else {
                      isNotEdited = true;
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _descriptionController,
                validator: requiredValidation,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Описание магазина',
                ),
                focusNode: _descriptionFocusNode,
                onChanged: (String val) {
                  setState(() {
                    if (val != user['shop']['description'] && val.isNotEmpty) {
                      isNotEdited = false;
                    } else {
                      isNotEdited = true;
                    }
                  });
                },
              ),
              const SizedBox(height: 30),
              GetBuilder<ProductsController>(
                builder: (_) {
                  final bool loading =
                      _.shopEditStatus == ShopEditStatus.Loading;
                  return CustomButton(
                    loading: loading,
                    width: double.infinity,
                    onPressed: isNotEdited ? () {} : () => _handleSubmit,
                    child: const Text('Изменить'),
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
