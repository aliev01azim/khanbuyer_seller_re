import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../helpers/alerts.dart';
import '../helpers/api_services.dart';

// ignore: constant_identifier_names
enum OrdersStatus { Initial, Loading }

class OrdersController extends GetxController {
  List _orders = [];
  List _detailedOrders = [];
  Map _processStatuses = {};
  OrdersStatus _ordersStatus = OrdersStatus.Initial;

  List get orders => _orders;
  List get detailedOrders => _detailedOrders;
  Map get processStatuses => _processStatuses;
  OrdersStatus get ordersStatus => _ordersStatus;
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

  Future<void> getDetailedOrders() async {
    _ordersStatus = OrdersStatus.Loading;
    update();
    try {
      dio.Response response = await getDetailedOrdersApi();
      final result = response.data;
      _detailedOrders = result;
    } catch (error) {
      errorAlert(error);
    } finally {
      _ordersStatus = OrdersStatus.Initial;
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
}
