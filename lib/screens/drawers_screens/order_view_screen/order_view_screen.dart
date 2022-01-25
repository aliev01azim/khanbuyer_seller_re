import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/orders_controller.dart';
import './widgets/products_list.dart';
import './widgets/total.dart';

class OrderViewScreen extends StatelessWidget {
  OrderViewScreen({Key? key}) : super(key: key);
  final _controller = Get.find<OrdersController>();
  Future<void> loadData() async {}
  @override
  Widget build(BuildContext context) {
    final Map order = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ №${order['id']}'),
      ),
      body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Column(
                children: [
                  ProductsList(
                    products: order['items'],
                  ),
                  Total(items: order['items']),
                ],
              ),
            );
          }),
    );
  }
}
