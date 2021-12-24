import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/shops_products_controller.dart';
import 'package:khanbuer_seller_re/helpers/constants.dart';

class Filters extends StatelessWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _shopController = Get.find<ShopsProductsController>();
    List values = _shopController.filters.values.toList();
    bool notEmpty = values.any((element) {
      if (element is List) {
        return element.isNotEmpty;
      } else {
        return element != null;
      }
    });

    if (!notEmpty) {
      return Container();
    }
    values = [];

    _shopController.filters.forEach((key, value) {
      if (value is List) {
        for (var element in value) {
          values.add('$key:$element');
        }
      } else {
        if (value != null) {
          values.add('$key:$value');
        }
      }
    });

    Map keyValues = {};

    for (var element in seasons) {
      keyValues['seasonality:${element['id']}'] = element['title'];
    }

    for (var element in sizes) {
      keyValues['size:${element['id']}'] = element['title'];
    }

    for (var element in _shopController.shops) {
      keyValues['shop_id:${element['id']}'] = element['title'];
    }

    for (var element in _shopController.categories) {
      keyValues['category_id:${element['id']}'] = element['title'];
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        direction: Axis.horizontal,
        children: values
            .map((e) => FilterItem(
                  title: keyValues[e],
                  onPressed: () => _shopController.removeFilter(e),
                ))
            .toList(),
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String title;
  final Function onPressed;

  const FilterItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            padding: const EdgeInsets.all(0),
            splashRadius: 20,
            icon: const Icon(Icons.close),
            onPressed: onPressed(),
            constraints: const BoxConstraints(maxHeight: 100),
          ),
        ],
      ),
    );
  }
}
