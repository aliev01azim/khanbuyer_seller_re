import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/products_controller.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/colors.dart';
import 'package:khanbuer_seller_re/helpers/validators.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/widgets/gender_picker.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/widgets/season_picker.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import '../../widgets/size_picker.dart';

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

class EditProductForm extends StatefulWidget {
  const EditProductForm({Key? key, required this.product}) : super(key: key);
  final dynamic product;
  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _controller = Get.find<ProductsController>();
  List _seasons = [];
  List _genders = [];
  List _sizes = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fabricStructureController =
      TextEditingController();

  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _fabricStructureFocusNode = FocusNode();
  @override
  void initState() {
    _titleController.text = widget.product['title'];
    _descriptionController.text = widget.product['description'];
    _fabricStructureController.text = widget.product['material'] ?? '';
    _seasons = widget.product['seasons'];
    _genders = widget.product['genders'];
    _sizes = widget.product['sizes'];
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fabricStructureController.dispose();

    _fabricStructureFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      List errors = [];
      if (_seasons.isEmpty) {
        errors.add('Сезонность');
      }
      if (_genders.isEmpty) {
        errors.add('Пол');
      }

      if (_sizes.isEmpty) {
        errors.add('Размеры');
      }

      if (errors.isNotEmpty) {
        return warningAlert('Необходимо заполнить поля: ${errors.join(', ')}');
      }

      final sizes = {};
      for (var id in _sizes) {
        id.remove('isChosen');
        sizes['size_ids[${id["id"]}]'] = id['id'];
      }
      final seasons = {};
      for (var id in _seasons) {
        id.remove('isChosen');
        seasons['season_ids[${id["id"]}]'] = id['id'];
      }
      final genders = {};
      for (var id in _genders) {
        id.remove('isChosen');
        genders['gender_ids[${id["id"]}]'] = id['id'];
      }

      dio.FormData formData = dio.FormData.fromMap({
        'id': widget.product['id'].toString(),
        'title': _titleController.text,
        'description': _descriptionController.text,
        'material': _fabricStructureController.text,
        'size_group':
            widget.product['category']['sizeTypes'][0]['id'].toString(),
        ...sizes,
        ...seasons,
        ...genders,
      });
      await _controller.editProduct(formData, widget.product['id'].toString());
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование продукта'),
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
                  controller: _titleController,
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
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_fabricStructureFocusNode);
                  },
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration,
                  style: textStyle,
                  focusNode: _descriptionFocusNode,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Состав',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: requiredValidation,
                        focusNode: _fabricStructureFocusNode,
                        controller: _fabricStructureController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: inputDecoration,
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                SizeTile(
                  sizes: _sizes,
                  allSizes: widget.product['category']['sizeTypes'][0]['sizes'],
                  onChanged: (value) => _sizes = value,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
                SeasonTile(
                  seasons: _seasons,
                  allSeasons: _controller.seasons,
                  onChanged: (value) => _seasons = value,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
                GenderTile(
                  genders: _genders,
                  allGenders: _controller.genders,
                  onChanged: (value) => _genders = value,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 28,
                    top: 15,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
