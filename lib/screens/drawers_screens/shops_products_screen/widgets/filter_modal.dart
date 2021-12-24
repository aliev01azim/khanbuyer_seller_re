import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';
import 'package:khanbuer_seller_re/helpers/constants.dart';
import 'package:khanbuer_seller_re/widgets/custom_button.dart';
import 'package:khanbuer_seller_re/widgets/options.dart';
import 'package:khanbuer_seller_re/widgets/select.dart';

class FilterModal extends StatefulWidget {
  final double modalHeight;

  const FilterModal(this.modalHeight, {Key? key}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  Map _filters = initialFilters;
  var spp = Get.find<ShopsProductsController>();

  @override
  void initState() {
    _filters = spp.filters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    spp = Get.find<ShopsProductsController>();
    return SizedBox(
      height: widget.modalHeight,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Фильтры'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Select(
                  options: spp.shops,
                  title: 'Поставщик',
                  value: _filters['shop_id'],
                  onChanged: (value) {
                    setState(() {
                      _filters['shop_id'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Select(
                  options: spp.categories,
                  title: 'Категория',
                  value: _filters['category_id'],
                  multi: true,
                  onChanged: (value) {
                    setState(() {
                      _filters['category_id'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Options(
                  options: seasons,
                  title: 'Сезонность',
                  value: _filters['seasonality'],
                  onChanged: (value) {
                    setState(() {
                      _filters['seasonality'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Options(
                  options: sizes,
                  title: 'Размеры',
                  value: _filters['size'],
                  onChanged: (value) {
                    setState(() {
                      _filters['size'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  height: 56,
                  width: double.infinity,
                  onPressed: () {
                    spp.setFilter(filters: _filters);
                    Get.back();
                  },
                  child: const Text(
                    'ПРИМЕНИТЬ',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  buttonStyle: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
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
