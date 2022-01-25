import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/colors.dart';
import '../../../../helpers/validators.dart';
import '../../order_view_screen/order_view_screen.dart';

const TextStyle defaultTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: 12,
);

class Item extends StatelessWidget {
  final String label;
  final dynamic value;
  final TextStyle textStyle;

  const Item({
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

class OrderInfo extends StatelessWidget {
  final Map order;

  const OrderInfo({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => OrderViewScreen(),
        arguments: order,
      ),
      child: Container(
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
            Item(
              label: 'Заказ №${order['id']}',
              value: formatDate(
                date: order['created_at'],
                format: 'dd.MM.yyyy',
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Item(
              label: 'Ф.И.О.:',
              value: order['recipient_name'],
            ),
            const SizedBox(height: 10),
            Item(
              label: 'Телефон:',
              value: order['recipient_phone_number'],
            ),
            const SizedBox(height: 10),
            Item(
              label: 'Адрес:',
              value: order['recipient_address'],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Сумма:',
                    style: defaultTextStyle,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '${order['sum_in_fact']}',
                          style: order['sum_in_fact'] < order['sum']
                              ? TextStyle(
                                  color: AppColors.favorite,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            // Row(
            //   children: [
            //     const Expanded(
            //       flex: 3,
            //       child:  Text(
            //         'Статус:',
            //         style: defaultTextStyle,
            //       ),
            //     ),
            //     Expanded(
            //       flex: 6,
            //       child: Consumer<SellerOrdersProvider>(
            //         builder: (_, p, w) {
            //           return Text(
            //             statuses[order['process_status']],
            //             style: TextStyle(
            //               color: AppColors.favorite,
            //               fontSize: 12,
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
