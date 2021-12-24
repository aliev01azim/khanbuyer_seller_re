import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';

// ignore: constant_identifier_names
enum ShopEditStatus { Initial, Loading }

class MyShopController extends GetxController {
  ShopEditStatus shopEditStatus = ShopEditStatus.Initial;
  var shop = user['shop'];
  Future<void> editShop(data) async {
    shopEditStatus = ShopEditStatus.Loading;
    update();
    try {
      dio.Response response = await editShopApi(data);
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        user['shop']['title'] = data['title'];
        user['shop']['description'] = data['description'];
        await sessionSaveUser(user);
        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        errorAlert(result);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      shopEditStatus = ShopEditStatus.Initial;

      update();
    }
  }
}
