import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/orders_controller.dart';

class Total extends StatelessWidget {
  final List items;

  const Total({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      child: GetBuilder<OrdersController>(
        builder: (_) {
          int quantity = 0;
          int summa = 0;
          _.orderDetails['grouped'].forEach((_, prod) {
            prod.forEach((value) {
              summa = summa +
                  (value['quantity_in_fact'] *
                      double.parse(value['price']).ceil() as int);
              quantity = quantity + value['quantity_in_fact'] as int;
            });
          });
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Всего линеек: ',
                    ),
                    TextSpan(
                      text: '$quantity шт.',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Общая сумма: ',
                    ),
                    TextSpan(
                      text: '$summa c',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
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
    );
  }
}
