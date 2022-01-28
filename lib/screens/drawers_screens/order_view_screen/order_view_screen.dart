import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/controllers/orders_controller.dart';
import '../../../helpers/app_dialog.dart';
import '../../../widgets/custom_button.dart';
import './widgets/products_list.dart';
import './widgets/total.dart';
import 'widgets/order_info.dart';

class OrderViewScreen extends StatelessWidget {
  OrderViewScreen({Key? key}) : super(key: key);
  final _controller = Get.find<OrdersController>();
  Future<void> loadData(id) async {
    if (_controller.orderId != id || _controller.orderDetails.isEmpty) {
      await _controller.getOrderDetails(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map order = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ №${order['id']}'),
      ),
      body: FutureBuilder(
          future: loadData(order['id']),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Column(
                children: [
                  OrderInfo(
                    order: order,
                  ),
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.none) ...[
                    ProductsList(
                      products: _controller.orderDetails,
                    ),
                    Total(items: order['items']),
                    CustomButtonForDialog(
                      child: const Text('ОТПРАВИТЬ'),
                      onPressed: () async => await Get.dialog(
                        AppOrdersDialog(
                          title: 'Вы уверены что хотите изменить заказ?',
                          onCancel: () => Get.back(),
                          onConfirm: () async =>
                              await _controller.editOrder(order),
                        ),
                      ),
                      height: 56,
                      buttonStyle: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ],
              ),
            );
          }),
    );
  }
}
