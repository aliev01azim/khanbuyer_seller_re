import 'dart:io';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../widgets/image_picker.dart';
import 'edit_product_form.dart';

class AddColorForm extends StatefulWidget {
  const AddColorForm(this.product, {Key? key}) : super(key: key);
  final dynamic product;
  @override
  _AddColorFormState createState() => _AddColorFormState();
}

class _AddColorFormState extends State<AddColorForm> {
  List<Asset> _images = [];
  final _controller = Get.find<ProductsController>();

  final List<String> _vals = const ['Да', 'Нет'];
  String? _selectedVal;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _inStockController = TextEditingController();

  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  // final FocusNode _inStockFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    // _inStockController.dispose();

    _codeFocusNode.dispose();
    _priceFocusNode.dispose();
    // _inStockFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      List imageBytes = [];
      for (int i = 0; i < _images.length; i++) {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(_images[i].identifier!);
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(filePath!);
        File compressedFile = await FlutterNativeImage.compressImage(
          filePath,
          quality: 90,
          targetWidth: 1000,
          targetHeight: (properties.height! * 1000 / properties.width!).round(),
        );
        final Map image = {
          'name': _images[i].name,
          'bytes': compressedFile.path
        };
        imageBytes.add(image);
      }

      if (_selectedVal == _vals[0] || _selectedVal == null) {
        _selectedVal = '1';
      } else {
        _selectedVal = '0';
      }

      dio.FormData formData = dio.FormData.fromMap({
        'product_id': widget.product['id'],
        'title': _titleController.text,
        'item_code': _codeController.text,
        'price': _priceController.text,
        'in_stock': _selectedVal,
        'images[]': imageBytes
            .map(
              (image) => dio.MultipartFile.fromFileSync(
                image['bytes'],
                filename: image['name'],
              ),
            )
            .toList(),
      });
      await _controller.addColor(formData, widget.product);
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarTitle: "Выбрано фотографий",
          allViewTitle: "Все фотографии",
          useDetailsView: false,
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление цвета'),
        centerTitle: true,
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
                ImagePicker(
                  images: _images,
                  loadAssets: loadAssets,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Цвет',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  validator: requiredValidation,
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_codeFocusNode);
                  },
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Код',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  validator: requiredValidation,
                  controller: _codeController,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: textStyle,
                  focusNode: _codeFocusNode,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Цена',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  validator: requiredValidation,
                  focusNode: _priceFocusNode,
                  controller: _priceController,
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context).requestFocus(_inStockFocusNode);
                  // },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'В наличии',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton(
                  value: _selectedVal ?? _vals[0],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVal = newValue!;
                    });
                  },
                  items: _vals.map((location) {
                    return DropdownMenuItem(
                      child: Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
                // TextFormField(
                //   validator: requiredValidation,
                //   focusNode: _inStockFocusNode,
                //   controller: _inStockController,
                //   textInputAction: TextInputAction.done,
                //   keyboardType: TextInputType.number,
                //   decoration: inputDecoration,
                //   style: textStyle,
                // ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 24,
                  ),
                  width: double.infinity,
                  child: GetBuilder<ProductsController>(
                    builder: (_) {
                      final bool loading = _.status == AddProductStatus.Loading;
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
