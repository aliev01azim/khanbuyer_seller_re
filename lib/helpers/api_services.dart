import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer';

const corsProxy = 'https://cors.prosoft.kg/';

class Config {
  static const baseUrl = 'https://khan.prosoft.kg';
}

Map user = Hive.box('userBox').get('user', defaultValue: {});

final dio = Dio(
  BaseOptions(
    baseUrl: kIsWeb ? corsProxy + Config.baseUrl : Config.baseUrl,
    contentType: Headers.formUrlEncodedContentType,
    headers: {'Authorization': 'Bearer ${user['auth_key'] as String}'},
  ),
);

final dio2 = Dio(
  BaseOptions(
    baseUrl: kIsWeb ? corsProxy + Config.baseUrl : Config.baseUrl,
    contentType: Headers.formUrlEncodedContentType,
  ),
);
Future<bool> checkConnection() async {
  try {
    if (!kIsWeb) {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      throw ('Нет интернет соединения');
    }
    return true;
  } on SocketException catch (_) {
    throw ('Нет интернет соединения');
  }
}

Future registerApi(data) async {
  await checkConnection();
  return dio2.post(
    '/api/user/register',
    data: data,
  );
}

Future<Response> checkConfirmationCodeApi(data) async {
  await checkConnection();
  var res = await dio2.post(
    '/api/user/check-confirmation-code',
    data: data,
  );
  //log('checkConfirmationCodeApi $res');
  return res;
}

Future loginApi() async {
  await checkConnection();

  return dio.post(
    '/api/user/login',
    data: {'seller': 1},
  );
}

Future editAccountApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/user/settings',
    data: data,
  );
}

Future resetPasswordApi(String code, String password) async {
  await checkConnection();
  return dio.post(
    '/api/user/reset-password',
    data: {'code': code, 'password': password},
  );
}

Future addAddressApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/user-address/add',
    data: data,
  );
}

Future deleteAddressApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/user-address/remove',
    data: data,
  );
}

Future editShopApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/user-shop/edit',
    data: data,
  );
}

Future addProductApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/add',
    data: data,
  );
}

Future editProductApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/edit',
    data: data,
  );
}

Future removeProductApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/remove',
    data: data,
  );
}

Future addColorApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/add-color',
    data: data,
  );
}

Future editColorApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/edit-color',
    data: data,
  );
}

Future removeColorApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/remove-color',
    data: data,
  );
}

Future getProductsApi(String filter) async {
  await checkConnection();
  return dio.get(
    '/api/seller-products?$filter',
  );
}

Future getProductApi(dynamic id) async {
  await checkConnection();
  return dio.get(
    '/api/seller-products/$id',
  );
}

Future getCategoriesApi() async {
  return dio2.get(
    '/api/categories/list',
  );
}

Future getSeasonsApi() async {
  return dio.get(
    '/api/seasons/list',
  );
}

Future getGendersApi() async {
  return dio.get(
    '/api/genders/list',
  );
}

Future getSizesTypesApi() async {
  return dio.get(
    '/api/size-types/list',
  );
}

Future setImageAsMainApi(data) async {
  return dio.post(
    '/api/seller-products/set-color-image-as-main',
    data: data,
  );
}

Future removeColorImageApi(data) async {
  return dio.post(
    '/api/seller-products/remove-color-image',
    data: data,
  );
}

Future getOrdersApi() async {
  await checkConnection();
  return dio.get(
    '/api/seller-orders/list?expand=items',
  );
}

Future getDetailedOrderApi(id) async {
  await checkConnection();
  return dio.get(
    '/api/seller-orders/$id?expand=items.product',
  );
}

Future getProcessStatusesApi() async {
  await checkConnection();
  return dio.get(
    '/api/orders/process-status-options',
  );
}

Future editOrderItemApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-orders/edit-item',
    data: data,
  );
}

Future editOrderApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-orders/edit',
    data: data,
  );
}
