// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'subScreens/sub_categories/sub_1.dart';

InputDecoration inputDecoration = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.border),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.hint),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.error),
  ),
  focusedErrorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.error),
  ),
  contentPadding: const EdgeInsets.all(0),
);

TextStyle textStyle = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w300,
);

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductScreen> {
  final _controller = Get.find<AddProductController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _descriptionFocusNode = FocusNode();

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      List errors = [];

      if (_nameController.text.isEmpty) {
        errors.add('Название');
      }
      if (_descriptionController.text.isEmpty) {
        errors.add('Описание');
      }
      if (_controller.categoryValues.isEmpty) {
        errors.add('Категория');
      }
      if (errors.isNotEmpty) {
        return warningAlert('Необходимо заполнить поля: ${errors.join(', ')}');
      }

      dio.FormData formData = dio.FormData.fromMap({
        'title': _nameController.text,
        'description': _descriptionController.text,
        'category_ids': _controller.categoryValues.last['id'].toString(),
      });
      await _controller.addProduct(
        formData,
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _globalKey = GlobalKey();
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Добавление продукта'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Категория',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GetBuilder<AddProductController>(
                  builder: (_) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(right: 0),
                      title: Text(_.categoryTitles),
                      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () => Get.to(() => SubCategories1()),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Наименование',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  validator: requiredValidation,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Описание',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  validator: requiredValidation,
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(
                    top: 24,
                    bottom: 28,
                  ),
                  width: double.infinity,
                  child: GetBuilder<AddProductController>(
                    builder: (_) {
                      final bool loading =
                          _.addProductStatus == AddProductStatus.Loading;
                      return CustomButton(
                        height: 56,
                        loading: loading,
                        onPressed: () => _handleSubmit,
                        buttonStyle: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        child: const Text(
                          'ДОБАВИТЬ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
