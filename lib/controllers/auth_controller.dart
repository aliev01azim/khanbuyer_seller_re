// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/screens/home_screen.dart';
import 'package:khanbuer_seller_re/screens/start_screens/otp_screen.dart';

import '../helpers/api_services.dart';
import '../helpers/user_session.dart' as u;
import '../helpers/alerts.dart';
import 'all_bindings.dart';

enum UserStatus {
  IsAuthenticated,
  Authenticating,
  Unauthenticated,
  WrongCredentials
}

enum UserEditStatus { Initial, Loading }

class AuthController extends GetxController {
  UserStatus status = UserStatus.Unauthenticated;
  bool loadingRecovery = false;
  late String code;
  UserEditStatus userEditStatus = UserEditStatus.Initial;
  // Future<void> login(email, password) async {
  //   status = UserStatus.Authenticating;
  //   update();
  //   try {
  //     dio.Response response = await loginApi(email, password);
  //     final result = response.data;
  //     if (result != null && result.containsKey('id')) {
  //       sessionSaveAuth(result);
  //       status = UserStatus.IsAuthenticated;
  //       _user = result;
  //       if (result['roles'].containsKey(Roles.seller)) {
  //         Get.off(() => BuyerScreen(), binding: AuthBinding());
  //       } else {
  //         Get.off(() => SellerScreen(), binding: AuthBinding());
  //       }
  //     } else {
  //       status = UserStatus.WrongCredentials;
  //       String errorMessage = result['message'];
  //       if (result['code'] == 0) {
  //         errorMessage =
  //             'Неверный email или пароль. Проверьте правильность данных.';
  //       }
  //       errorAlert(errorMessage);
  //     }
  //     // SharedPreferences session = await SharedPreferences.getInstance();
  //     // session.getBool(key)
  //   } on dio.DioError catch (error) {
  //     String errorMessage = error.response!.data.toString();
  //     if (error.response!.data.containsKey('code') &&
  //         error.response!.data['code'] == 0) {
  //       errorMessage =
  //           'Неверный email или пароль. Проверьте правильность данных.';
  //     }
  //     errorAlert(errorMessage);
  //     status = UserStatus.WrongCredentials;
  //   } catch (error) {
  //     errorAlert(error);
  //     status = UserStatus.Unauthenticated;
  //   } finally {
  //     update();
  //   }
  // }

  Future<void> register(String number) async {
    status = UserStatus.Authenticating;
    update();
    try {
      dio.Response response = await registerApi(number);
      final result = response.data;
      if (result != null && result['success']) {
        status = UserStatus.IsAuthenticated;
        await u.sessionSaveUser(result['user']);

        await Get.to(() => const OtpScreen());
      } else {
        status = UserStatus.WrongCredentials;
        String errors = '';
        if (result.containsKey('errors') && result['errors'].isNotEmpty) {
          result['errors'].forEach((key, value) {
            errors = errors + value[0] + '. ';
          });
        } else {
          errors = result.toString();
        }
        errorAlert(errors);
      }
    } catch (error) {
      errorAlert(error);
      status = UserStatus.WrongCredentials;
    } finally {
      update();
    }
  }

  // Future<void> logout() async {
  //   await Hive.box('userBox').clear();
  //   status = UserStatus.Unauthenticated;
  //   Get.offAll(const AuthScreen());
  //   update();
  // }

  // Future<void> checkSession() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? userString = preferences.getString('user');
  //   if (userString != null) {
  //     Map user = json.decode(userString);
  //     status = UserStatus.IsAuthenticated;
  //     _user = user;
  //     if (user['roles'].containsKey(Roles.seller)) {
  //       Get.off(() => BuyerScreen(), binding: AuthBinding());
  //     } else {
  //       Get.off(() => SellerScreen(), binding: AuthBinding());
  //     }
  //   } else {
  //     Get.off(const AuthScreen());
  //   }
  // }
  // Future<void> requestRecoveryMessage(email) async {
  //   loadingRecovery = true;
  //   update();
  //   try {
  //     dio.Response response = await requestRecoveryMessageApi(email);
  //     final result = response.data;
  //     if (!result['success']) {
  //       errorAlert(result['errors']['email']);
  //     } else {
  //       email = email;
  //       Get.toNamed('/check-confirmation-code');
  //     }
  //   } catch (error) {
  //     errorAlert(error);
  //   } finally {
  //     loadingRecovery = false;
  //     update();
  //   }
  // }

  Future<void> checkConfirmationCode(cod) async {
    loadingRecovery = true;
    update();

    try {
      dio.Response response = await checkConfirmationCodeApi(cod);
      final result = response.data;
      if (!result['success']) {
        status = UserStatus.WrongCredentials;
        errorAlert(result['errors']['code']);
      } else {
        dio.Response response2 = await loginApi();
        await u.sessionSaveUser(response2.data);
        code = cod;
        status = UserStatus.IsAuthenticated;
        Get.offAll(() => SellerScreen(), binding: AuthBinding());
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      loadingRecovery = false;
      update();
    }
  }

  // Future<void> resetPassword(password) async {
  //   loadingRecovery = true;
  //   update();
  //   try {
  //     dio.Response response = await resetPasswordApi(code, password);
  //     final result = response.data;
  //     if (!result['success']) {
  //       if (result['errors'].containsKey('code')) {
  //         errorAlert(result['errors']['code']);
  //       } else {
  //         errorAlert(result['errors']);
  //       }
  //     } else {
  //       Get.offAll(const AuthScreen());
  //       successAlert('Новый пароль успешно установлен');
  //     }
  //   } catch (error) {
  //     errorAlert(error);
  //   } finally {
  //     loadingRecovery = false;
  //     update();
  //   }
  // }

  Future<void> editFio(String data) async {
    userEditStatus = UserEditStatus.Loading;
    update();
    try {
      dio.Response response = await editAccountApi({'full_name': data});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        await u.sessionSaveUser(result['user']);

        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        errorAlert(result);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      userEditStatus = UserEditStatus.Initial;
      update();
    }
  }

  Future<void> editDate(String data) async {
    userEditStatus = UserEditStatus.Loading;
    update();
    try {
      dio.Response response = await editAccountApi({'birth_date': data});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        await u.sessionSaveUser(result['user']);

        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        errorAlert(result);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      userEditStatus = UserEditStatus.Initial;
      update();
    }
  }

  Future<void> editEmail(String data) async {
    userEditStatus = UserEditStatus.Loading;
    update();
    try {
      dio.Response response = await editAccountApi({'unconfirmed_email': data});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        await u.sessionSaveUser(result['user']);

        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        errorAlert(result);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      userEditStatus = UserEditStatus.Initial;
      update();
    }
  }

  Future<void> editGender(String data) async {
    userEditStatus = UserEditStatus.Loading;
    update();
    try {
      dio.Response response = await editAccountApi({'gender': data});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        await u.sessionSaveUser(result['user']);
        Get.back();
        successAlert('Данные успешно обновлены!');
      } else {
        errorAlert(result);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      userEditStatus = UserEditStatus.Initial;
      update();
    }
  }

  // Future<void> editAccount(data) async {
  //   userEditStatus = UserEditStatus.Loading;
  //   update();
  //   try {
  //     dio.Response response = await editAccountApi(data);
  //     final result = response.data;
  //     if (result.containsKey('success') && result['success']) {
  //       _user = result['user'];
  //       sessionSaveUser(result['user']);
  //       successAlert('Данные успешно обновлены!');
  //     } else {
  //       errorAlert(result);
  //     }
  //   } catch (error) {
  //     errorAlert(error);
  //   } finally {
  //     userEditStatus = UserEditStatus.Initial;
  //     update();
  //   }
  // }
}
