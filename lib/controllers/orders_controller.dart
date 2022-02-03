// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../helpers/alerts.dart';
import '../helpers/api_services.dart';

enum OrdersStatus { Initial, Loading }
enum EditOrderStatus { Initial, Loading }
enum EditItemStatus { Initial, Loading }

class OrdersController extends GetxController {
  List _orders = [];
  Map _orderDetails = {};
  int _orderId = 0;
  Map _processStatuses = {};
  int _colorId = 0;
  OrdersStatus _ordersStatus = OrdersStatus.Initial;
  EditOrderStatus _editOrderStatus = EditOrderStatus.Initial;
  EditItemStatus _editItemStatus = EditItemStatus.Initial;

  List get orders => _orders;
  int get orderId => _orderId;
  Map get orderDetails => _orderDetails;
  Map get processStatuses => _processStatuses;
  int get colorId => _colorId;
  OrdersStatus get ordersStatus => _ordersStatus;
  EditOrderStatus get editOrderStatus => _editOrderStatus;
  EditItemStatus get editItemStatus => _editItemStatus;
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
      _orderDetails = o;
    } catch (error) {
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

  Future<void> editOrderItem(id, quantity, prodId) async {
    // print(_orderDetails['grouped'][prodId][orderIndex]['quantity_in_fact']);
    _editItemStatus = EditItemStatus.Loading;
    _colorId = id;
    update();
    try {
      final Map data = {
        'id': id,
        'quantity_in_fact': quantity,
        'is_added_to_order': 1,
      };

      dio.Response response = await editOrderItemApi(data);
      if (response.data['success']) {
        final order = _orderDetails['grouped'][prodId]
            .firstWhere((element) => element['id'] == id);
        final orderIndex = _orderDetails['grouped'][prodId].indexOf(order);
        _orderDetails['grouped'][prodId][orderIndex]['quantity_in_fact'] =
            quantity;
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

  Future<void> editOrder(order) async {
    try {
      _editOrderStatus = EditOrderStatus.Loading;
      update();

      final Map data = {
        'id': order['id'],
        'recipient_name': order['recipient_name'],
        'recipient_phone_number': order['recipient_phone_number'],
        'recipient_address': order['recipient_address'],
        'process_status': 3,
      };
      dio.Response response = await editOrderApi(data);
      final result = response.data;
      if (result['success']) {
        final _order =
            _orders.firstWhere((element) => element['id'] == order['id']);
        final _orderIndex = _orders.indexOf(_order);
        _orders[_orderIndex]['process_status'] =
            result['product']['process_status'];
        _orders[_orderIndex]['sum_in_fact'] = result['product']['sum_in_fact'];
        Get.back(closeOverlays: true);
        successAlert(response.data['message']);
      } else {
        errorAlert(response.data);
      }
    } on dio.DioError catch (error) {
      errorAlert(error.response?.data);
    } catch (error) {
      errorAlert(error);
    } finally {
      _editOrderStatus = EditOrderStatus.Initial;
      update();
    }
  }
}
