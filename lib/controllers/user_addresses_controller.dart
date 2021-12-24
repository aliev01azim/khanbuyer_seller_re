import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as dio;
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';
import 'package:khanbuer_seller_re/helpers/user_session.dart';

// ignore: constant_identifier_names
enum AddressEditStatus { Initial, Loading }

class UserAddressesController extends GetxController {
  AddressEditStatus addressEditStatus = AddressEditStatus.Initial;
  var addresses = [];
  var user = {};
  Future<void> addAddress(data) async {
    addressEditStatus = AddressEditStatus.Loading;
    update();
    try {
      dio.Response response = await addAddressApi(data);
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        addresses.add(data);

        await Hive.box('userBox').delete('addresses');

        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        var errors = '';
        if (result['errors'].isNotEmpty) {
          result['errors'].forEach((val) {
            val.forEach((key, value) {
              errors = errors + value[0] + '. ';
            });
          });
        } else {
          errors = result.toString();
        }
        errorAlert(errors);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      addressEditStatus = AddressEditStatus.Initial;
      update();
    }
  }

  Future<void> getAddresses() async {
    addressEditStatus = AddressEditStatus.Loading;
    update();
    try {
      dio.Response response = await editAccountApi(user);
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        addresses = result['user']['addresses'];
        user = result['user'];
        await sessionSaveUser(result['user']);
      } else {
        var errors = '';
        if (result['errors'].isNotEmpty) {
          result['errors'].forEach((val) {
            val.forEach((key, value) {
              errors = errors + value[0] + '. ';
            });
          });
        } else {
          errors = result.toString();
        }
        errorAlert(errors);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      addressEditStatus = AddressEditStatus.Initial;
      update();
    }
  }

  Future<bool> deleteAddress(dynamic address) async {
    try {
      dio.Response response =
          await deleteAddressApi({'id': address['id'].toString()});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        addresses.remove(address);

        return true;
      } else {
        var errors = '';
        if (result['message'] != null) {
          errors = result['message'];
        } else {
          errors = result.toString();
        }
        errorAlert(errors);
        return false;
      }
    } catch (error) {
      errorAlert(error);
      return false;
    } finally {
      update();
    }
  }
}
