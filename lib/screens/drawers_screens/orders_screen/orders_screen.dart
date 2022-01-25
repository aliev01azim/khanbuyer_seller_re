import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/orders_controller.dart';
import '../../../widgets/drawer.dart';
import 'widgets/orders_list.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);
  final _controller = Get.find<OrdersController>();
  Future<void> loadData({bool reload = false}) async {
    if (reload || _controller.orders.isEmpty) {
      await _controller.getOrders();
    }
    if (reload || _controller.processStatuses.isEmpty) {
      await _controller.getProcessStatuses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: loadData(),
        builder: (c, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.none) {
            return RefreshIndicator(
              onRefresh: () => loadData(reload: true),
              child: const OrdersList(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
