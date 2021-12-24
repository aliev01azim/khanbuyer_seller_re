import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'user_session.dart';

const corsProxy = 'https://cors.prosoft.kg/';

class Config {
  static const baseUrl = 'https://khan.prosoft.kg';
}

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

Future loginApi(String email, String password) async {
  await checkConnection();

  final String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$email:$password'));

  return dio.post(
    '/api/users/login',
    options: Options(headers: {'Authorization': basicAuth}),
  );
}

Future registerApi(String number) async {
  await checkConnection();
  return dio2.post(
    '/api/user/register',
    data: {'username': number},
  );
}

Future requestRecoveryMessageApi(String email) async {
  await checkConnection();

  return dio.post(
    '/api/user/request-recovery-message',
    data: {'email': email},
  );
}

Future checkConfirmationCodeApi(String code) async {
  await checkConnection();

  return dio2.post(
    '/api/user/check-confirmation-code',
    data: {'code': code},
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

Future removeProductApi(data) async {
  await checkConnection();
  return dio.post(
    '/api/seller-products/remove',
    data: data,
  );
}

Future addColorApi(Map<String, dynamic> params) async {
  return dio.post(
    '/api/color/add',
    queryParameters: params,
  );
}

Future getSellerShopsApi() async {
  return dio.get(
    '/api/shops?ShopSearch[user_id]=${user['id']}',
  );
}

Future getBrandsApi() async {
  return dio.get('/api/brands/list');
}

Future getProductsApi(String filter) async {
  await checkConnection();
  final role =
      user['roles'].containsKey(Roles.customer) ? 'seller' : 'customer';
  return dio.get(
    '/api/$role-products?$filter',
  );
}

Future getCustomerShopsApi() async {
  await checkConnection();
  return dio.get(
    '/api/customer-shops?expand=shop.pictures',
  );
}

Future getCategoriesApi() async {
  return dio2.get(
    '/api/categories/list',
  );
}

Future getColorsApi() async {
  return dio.get(
    '/api/colors/list',
  );
}

Future addToFavoritesApi(int id) async {
  await checkConnection();

  return dio.post(
    '/api/user-favorite-products/add?product_id=$id',
  );
}

Future getFavoritesApi() async {
  await checkConnection();

  return dio.get(
    '/api/user-favorite-products/list',
  );
}

Future removeFavoriteApi(int id) async {
  await checkConnection();

  return dio.post(
    '/api/user-favorite-products/remove?product_id=$id',
  );
}
