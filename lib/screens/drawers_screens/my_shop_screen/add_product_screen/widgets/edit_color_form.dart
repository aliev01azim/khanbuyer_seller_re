import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../widgets/image_picker.dart';
import 'edit_product_form.dart';

class EditColorForm extends StatefulWidget {
  const EditColorForm(this.productId, this.color, {Key? key}) : super(key: key);
  final dynamic productId;
  final dynamic color;
  @override
  _EditColorFormState createState() => _EditColorFormState();
}

class _EditColorFormState extends State<EditColorForm> {
  List<Asset> _images = [];
  final _controller = Get.find<ProductsController>();
  List _networkImages = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  final List<String> _vals = const ['Да', 'Нет'];
  String _selectedVal = 'Да';
  @override
  void initState() {
    _titleController.value = TextEditingValue(text: widget.color['title']);
    _codeController.value = TextEditingValue(text: widget.color['item_code']);
    _priceController.value = TextEditingValue(text: widget.color['price']);
    _selectedVal = widget.color['inStockTitle'];
    _networkImages = widget.color['pictures']
        .where((element) => element['id'] != null)
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _priceController.dispose();

    _codeFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      List imageBytes = [];
      for (int i = 0; i < _images.length; i++) {
        ByteData byteData = await _images[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        final Map image = {'name': _images[i].name, 'bytes': imageData};
        imageBytes.add(image);
      }

      if (_selectedVal == _vals[0] || _selectedVal == null) {
        _selectedVal = '1';
      } else {
        _selectedVal = '0';
      }

      dio.FormData formData = dio.FormData.fromMap({
        'id': widget.color['id'].toString(),
        'title': _titleController.text,
        'item_code': _codeController.text,
        'price': _priceController.text,
        'in_stock': _selectedVal,
        'images[]': imageBytes
            .map((image) => dio.MultipartFile.fromBytes(
                  image['bytes'],
                  filename: image['name'],
                ))
            .toList(),
      });
      await _controller.editColor(formData, widget.productId);
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
        title: const Text('Редактирование цвета'),
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
                EditingImagePicker(
                  colorId: widget.color['id'],
                  productId: widget.productId,
                  images: _images,
                  networkImages: _networkImages,
                  loadAssets: loadAssets,
                  localRemove: (image) {
                    setState(() {
                      _images.removeWhere((i) => i == image);
                    });
                  },
                  localRemoveForNetImages: (image) {
                    setState(() {
                      _networkImages.removeWhere((ni) => ni == image);
                    });
                  },
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
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Наличие',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton(
                  value: _selectedVal,
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
                          'ИЗМЕНИТЬ',
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
