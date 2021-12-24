import 'dart:io';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:khanbuer_seller_re/controllers/add_product_controller.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import './image_picker.dart';
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

class AddProductFormNext extends StatefulWidget {
  const AddProductFormNext({Key? key}) : super(key: key);

  @override
  _AddProductFormNextState createState() => _AddProductFormNextState();
}

class _AddProductFormNextState extends State<AddProductFormNext> {
  List<int> _categories = [];
  List _colors = [];
  int? _seasonality;
  int? _inStock;
  List<Asset> _images = [];
  Map _size = {'min': '', 'max': ''};
  final _controller = Get.find<AddProductController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    _nameController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      List errors = [];

      if (_categories.isEmpty) {
        errors.add('Категория');
      }
      if (_colors.isEmpty) {
        errors.add('Цвета');
      }
      if (_seasonality == null) {
        errors.add('Сезонность');
      }
      if (_inStock == null) {
        errors.add('Наличие');
      }
      if (_size['min'] == '') {
        errors.add('Мин. размер');
      }
      if (_size['max'] == '') {
        errors.add('Макс. размер');
      }
      if (errors.isNotEmpty) {
        return warningAlert('Необходимо заполнить поля: ${errors.join(', ')}');
      }
      final categories = {};
      for (var id in _categories) {
        categories['category_ids[$id]'] = id;
      }
      final colors = {};
      for (var color in _colors) {
        colors['color_ids[${color['id']}]'] = color['id'];
      }

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

        print(' compressImage------- ${compressedFile.lengthSync()}');

        // ByteData byteData = await _images[i].getByteData();

        // List<int> imageData = byteData.buffer.asUint8List();

        final Map image = {
          'name': _images[i].name,
          'bytes': compressedFile.path
        };
        imageBytes.add(image);
      }

      // dio.FormData formData = dio.FormData.fromMap({
      //   ...categories,
      //   ...colors,
      //   'name': _nameController.text,
      //   'item_code': _descriptionController.text,
      //   'size_min': _size['min'],
      //   'size_max': _size['max'],
      //   'seasonality': _seasonality,
      //   'in_stock': _inStock,
      //   'images[]': imageBytes
      //       .map(
      //         (image) => dio.MultipartFile.fromFileSync(
      //           image['bytes'],
      //           filename: image['name'],
      //         ),
      //       )
      //       .toList(),
      // });
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
        title: const Text('Добавьте дополнительно'),
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
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  // },
                  decoration: inputDecoration,
                  style: textStyle,
                ),
                const SizedBox(height: 20),
                // SmartSelect<int>.single(
                //   placeholder: 'Выбрать',
                //   modalType: S2ModalType.fullPage,
                //   title: 'Магазин',
                //   selectedValue: _shop ?? 1,
                //   choiceItems: _controller.shops,
                //   onChange: (state) => _shop = state.value!,
                //   tileBuilder: (_, state) => SSTile(state: state),
                //   modalBuilder: (_, state) => SSModalBuilder(
                //     state: state,
                //     title: 'Магазин',
                //   ),
                //   choiceBuilder: (_, state, s) => SSChoiceBuilder(state: state),
                // ),
                // const SizedBox(height: 2),
                // SmartSelect<int>.multiple(
                //   placeholder: 'Выбрать',
                //   modalType: S2ModalType.fullPage,
                //   title: 'Категория',
                //   selectedValue: _categories,
                //   choiceItems: _controller.categories,
                //   onChange: (state) => _categories = state!.value!,
                //   tileBuilder: (_, state) => SSTile(state: state),
                //   modalBuilder: (_, state) => SSModalBuilder(
                //     state: state,
                //     title: 'Категория',
                //   ),
                // choiceBuilder: (_, state, s) => SSChoiceBuilder(
                //   state: state,
                //   choice: s,
                // ),
                // ),
                // const SizedBox(height: 2),
                // ColorsTile(
                //   colors: _colors,
                //   allColors: _controller.colors,
                //   onChanged: (value) => _colors = value,
                // ),
                // const SizedBox(height: 2),

                // SmartSelect<int>.single(
                //   placeholder: 'Выбрать',
                //   modalType: S2ModalType.fullPage,
                //   title: 'Сезонность',
                //   selectedValue: _seasonality ?? 1,
                //   choiceItems: s2SeasonsList,
                //   onChange: (state) => _seasonality = state.value!,
                //   tileBuilder: (_, state) => SSTile(state: state),
                //   modalBuilder: (_, state) => SSModalBuilder(
                //     state: state,
                //     title: 'Сезонность',
                //   ),
                //   choiceBuilder: (_, state, s) => SSChoiceBuilder(state: state),
                // ),
                // const SizedBox(height: 2),
                // SizeTile(
                //   size: _size,
                //   onChanged: (value) => _size = value,
                // ),

                // Container(
                //   margin: const EdgeInsets.symmetric(vertical: 10),
                //   padding: const EdgeInsets.all(15),
                //   color: Colors.white,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //
                //
                //       const Text(
                //         'Артикул',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       TextFormField(
                //         validator: requiredValidation,
                //         focusNode: _codeFocusNode,
                //         controller: _codeController,
                //         textInputAction: TextInputAction.next,
                //         keyboardType: TextInputType.text,
                //         decoration: inputDecoration,
                //         onFieldSubmitted: (_) {
                //           FocusScope.of(context).requestFocus(_priceFocusNode);
                //         },
                //         style: textStyle,
                //       ),
                //       const SizedBox(height: 20),
                //       const Text(
                //         'Цена',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       TextFormField(
                //         validator: requiredValidation,
                //         focusNode: _priceFocusNode,
                //         controller: _priceController,
                //         textInputAction: TextInputAction.next,
                //         keyboardType: TextInputType.number,
                //         decoration: inputDecoration,
                //         onFieldSubmitted: (_) {
                //           FocusScope.of(context)
                //               .requestFocus(_fabricStructureFocusNode);
                //         },
                //         style: textStyle,
                //       ),
                //       const SizedBox(height: 20),
                //       const Text(
                //         'Состав',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       TextFormField(
                //         validator: requiredValidation,
                //         focusNode: _fabricStructureFocusNode,
                //         controller: _fabricStructureController,
                //         textInputAction: TextInputAction.done,
                //         keyboardType: TextInputType.text,
                //         decoration: inputDecoration,
                //         style: textStyle,
                //       ),
                //     ],
                //   ),
                // ),

                // SmartSelect<int>.single(
                //   placeholder: 'Выбрать',
                //   modalType: S2ModalType.bottomSheet,
                //   title: 'Наличие',
                //   selectedValue: _inStock ?? 1,
                //   choiceItems: [
                //     S2Choice<int>(value: 0, title: 'Нет в наличии'),
                //     S2Choice<int>(value: 1, title: 'В наличии')
                //   ],
                //   onChange: (state) => _inStock = state.value!,
                //   tileBuilder: (_, state) => SSTile(state: state),
                //   choiceBuilder: (_, state, s) => SSChoiceBuilder(state: state),
                // ),
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
