import 'package:flutter/material.dart';

import '../../orders_screen/widgets/order_info.dart';

class Item extends StatelessWidget {
  const Item(this.item, {Key? key}) : super(key: key);
  final dynamic item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 25,
        left: 15,
        right: 15,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(238, 238, 238, 1),
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Продукт №${item['id']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RowItem(
            label: 'Продукт:',
            value: item['product_name'],
          ),
          const SizedBox(height: 10),
          RowItem(
            label: 'Поставщик:',
            value: item['shop_name'],
          ),
          const SizedBox(height: 10),
          RowItem(
            label: 'Цвет:',
            value: item['color_name'],
          ),
          const SizedBox(height: 10),
          RowItem(
            label: 'Цена:',
            value: '${item['price']} сом',
          ),
          const SizedBox(height: 10),
          RowItem(
            label: 'Количество:',
            value: item['quantity_in_fact'],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String label;
  final dynamic value;
  final TextStyle textStyle;

  const RowItem({
    Key? key,
    required this.label,
    this.value,
    this.textStyle = defaultTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: textStyle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            '$value',
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
