// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../helpers/alerts.dart';
import '../helpers/api_services.dart';

enum OrdersStatus { Initial, Loading }
enum EditOrderStatus { Initial, Loading }
enum EditItemStatus { Initial, Loading }

class OrdersController extends GetxController {
  List _orders = [];
  List _orderDetails = [];
  int _orderId = 0;
  Map _processStatuses = {};
  OrdersStatus _ordersStatus = OrdersStatus.Initial;
  EditOrderStatus _editOrderStatus = EditOrderStatus.Initial;
  EditItemStatus _editItemStatus = EditItemStatus.Initial;

  List get orders => _orders;
  int get orderId => _orderId;
  List get orderDetails => _orderDetails;
  Map get processStatuses => _processStatuses;
  OrdersStatus get ordersStatus => _ordersStatus;
  EditOrderStatus get editOrderStatus => _editOrderStatus;
  Future<void> getOrders() async {
    _ordersStatus = OrdersStatus.Loading;
    update();
    try {
      dio.Response response = await getOrdersApi();
      final result = response.data;
      _orders = result;
    } catch (error) {
      errorAlert(error);
    } finally {
      _ordersStatus = OrdersStatus.Initial;
      update();
    }
  }

  Future<void> getOrderDetails(id) async {
    try {
      dio.Response response = await getDetailedOrderApi(id);
      _orderId = id;
      List orders = [];
      Map<int, dynamic> grouped = <int, dynamic>{};
      for (var item in response.data['items']) {
        if (grouped.containsKey(item['product_id'])) {
          grouped[item['product_id']].add(item);
        } else {
          grouped[item['product_id']] = [item];
        }
      }
      final Map o = {
        ...response.data,
        'grouped': grouped,
      };
      orders.add(o);
      _orderDetails = orders;
    } catch (error) {
      print(error);
      errorAlert(error);
    } finally {
      update();
    }
  }

  Future<void> getProcessStatuses() async {
    _ordersStatus = OrdersStatus.Loading;
    update();
    try {
      dio.Response response = await getProcessStatusesApi();
      final result = response.data;
      _processStatuses = result;
    } catch (error) {
      errorAlert(error);
    } finally {
      _ordersStatus = OrdersStatus.Initial;
      update();
    }
  }

  Future<void> editItem(id, quantity, args) async {
    _editItemStatus = EditItemStatus.Loading;
    update();
    try {
      final Map data = {
        'id': id,
        'quantity_in_fact': quantity,
        'is_added_to_order': 1,
      };
      dio.Response response = await editOrderItemApi(data);
      if (response.data['success']) {
        _orderDetails[args['productId']]['orders'][args['orderId']]['colors']
            .removeWhere((color) => color['item_id'] == id);
        if (_orderDetails[args['productId']]['orders'][args['orderId']]
                ['colors']
            .isEmpty) {
          Get.back();
          _orderDetails[args['productId']]['orders'].remove(args['orderId']);
          if (_orderDetails[args['productId']]['orders'].isEmpty) {
            Get.back();
            _orderDetails.remove(args['productId']);
          }
        }
      }
    } on dio.DioError catch (e) {
      errorAlert(e.response);
    } catch (e) {
      errorAlert(e);
    } finally {
      _editItemStatus = EditItemStatus.Initial;
      update();
    }
  }

  Future<void> editOrder(args, requestBody, statusCode) async {
    _editOrderStatus = EditOrderStatus.Loading;
    update();
    try {
      dio.Response response = await editOrderApi(requestBody);
      if (response.data['success']) {
        _orders[args['productId']]['orders'][args['orderId']]
            ['process_status'] = statusCode;
        _orders[args['productId']]['orders'][args['orderId']] = response.data;
      }
    } on dio.DioError catch (e) {
      errorAlert(e.response);
    } catch (e) {
      errorAlert(e);
    } finally {
      _editOrderStatus = EditOrderStatus.Initial;
      update();
    }
  }
}
