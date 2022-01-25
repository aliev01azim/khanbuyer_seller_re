import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/orders_controller.dart';
import 'order_info.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (_) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          itemCount: _.orders.length,
          itemBuilder: (ctx, i) {
            return OrderInfo(
              order: _.orders[i],
            );
          },
        );
      },
    );
  }
}
