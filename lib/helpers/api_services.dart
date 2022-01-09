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

Future getProductsApi() async {
  await checkConnection();
  return dio.get(
    '/api/seller-products',
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
