import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/add_product_screen/widgets/product_view.dart';

import '../helpers/user_session.dart';

// ignore: constant_identifier_names
enum AddProductStatus { Initial, Loading, Error }
// ignore: constant_identifier_names
enum ShopEditStatus { Initial, Loading }

class ProductsController extends GetxController {
  AddProductStatus status = AddProductStatus.Initial;
  List _products = [];
  List _categories = [];
  List _seasons = [];
  List _genders = [];
  List _sizeTypes = [];

  AddProductStatus get addProductStatus => status;

  List get categories => _categories;
  List get products => _products.reversed.toList();
  List get seasons => _seasons;
  List get genders => _genders;
  List get sizeTypes => _sizeTypes;

  dynamic _editedProduct;
  dynamic get editedProduct => _editedProduct;

  Future<void> getSellerProducts({
    bool filter = false,
  }) async {
    // if (filter) {
    //   _pageIndex = 1;
    //   _status = Status.Loading;
    //   _products = [];
    //   update();
    // }
    // dynamic params = [
    //   'per-page=20',
    //   'page=$_pageIndex',
    // ];
    // _filters.forEach((key, value) {
    //   if (value is List) {
    //     for (var element in value) {
    //       if (key == 'category_id') {
    //         params.add('ProductSearch[category_ids][]=$element');
    //       } else {
    //         params.add('ProductSearch[$key]=$element');
    //       }
    //     }
    //   } else {
    //     if (value != null) {
    //       if (key == 'size') {
    //         params.add('ProductSearch[$value]=56');
    //       } else {
    //         params.add('ProductSearch[$key]=$value');
    //       }
    //     }
    //   }
    // });
    // params.removeWhere((String element) => element.endsWith('=null'));
    // params = params.join('&');
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await getProductsApi();
      final result = response.data;
      List _prods = [];
      result.forEach((p) {
        _prods.add(p);
      });
      _products = _prods;
      print('products : $result');
      status = AddProductStatus.Initial;
    } on dio.DioError catch (error) {
      status = AddProductStatus.Error;
      errorAlert(error.response!.data);
    } catch (error) {
      status = AddProductStatus.Error;
      errorAlert(error);
    } finally {
      update();
    }
  }

  Future<void> removeProduct(id) async {
    status = AddProductStatus.Loading;

    update();
    try {
      dio.Response response = await removeProductApi({'id': id});
      final result = response.data;
      if (result.containsKey('success') && result['success']) {
        _products.removeWhere((element) => element['id'] == id);
        Get.back(closeOverlays: true);
        successAlert(result['message']);
      } else {
        errorAlert(result);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  Future<void> getCategories() async {
    try {
      dio.Response response = await getCategoriesApi();
      final result = response.data;

      List categories = [];
      result.forEach((category) {
        categories.add(category);
      });

      _categories = categories;
    } catch (e) {
      errorAlert(e);
    } finally {
      update();
    }
  }

  Future<void> getSeasons() async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await getSeasonsApi();
      final result = response.data;
      List _seas = [];
      result.forEach((p) {
        _seas.add(p);
      });
      _seasons = _seas;
      status = AddProductStatus.Initial;
    } catch (e) {
      status = AddProductStatus.Error;
      errorAlert(e);
    } finally {
      update();
    }
  }

  Future<void> getGenders() async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await getGendersApi();
      final result = response.data;
      List _gens = [];
      result.forEach((p) {
        _gens.add(p);
      });
      _genders = _gens;
      status = AddProductStatus.Initial;
      print({'genders': _genders});
    } catch (e) {
      status = AddProductStatus.Error;
      errorAlert(e);
    } finally {
      update();
    }
  }

  Future<void> getSizeTypes() async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await getSeasonsApi();
      final result = response.data;
      List _szs = [];
      result.forEach((p) {
        _szs.add(p);
      });
      _sizeTypes = _szs;
      status = AddProductStatus.Initial;
    } catch (e) {
      status = AddProductStatus.Error;
      errorAlert(e);
    } finally {
      update();
    }
  }

  Future<void> addProduct(formData) async {
    try {
      status = AddProductStatus.Loading;
      update();
      dio.Response response = await addProductApi(formData);
      if (response.data['success']) {
        _products.add(response.data['product']);
        Get.back(closeOverlays: true);
        successAlert('Продукт добавлен!');
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  Future<void> editProduct(formData, productId) async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await editProductApi(formData);
      if (response.data['success']) {
        final product = _products
            .firstWhere((element) => element['id'].toString() == productId);
        final prodIndex = _products.indexOf(product);
        _products[prodIndex] = response.data['product'];
        _editedProduct = response.data['product'];
        Get.back(closeOverlays: true);
        Get.back(closeOverlays: true);
        Get.to(() => ProductScreen(_editedProduct));
        successAlert('Продукт изменён!');
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  Future<void> addColor(formData, product) async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await addColorApi(formData);
      if (response.data['success']) {
        final prodIndex = _products.indexOf(product);
        final color = _products[prodIndex]['colors'].firstWhere(
          (c) => c['id'] == response.data['product']['id'],
          orElse: () => null,
        );
        if (color != null) {
          final colorIndex = _products[prodIndex]['colors'].indexOf(color);
          _products[prodIndex]['colors'][colorIndex] = response.data['product'];
        } else {
          _products[prodIndex]['colors'].add(response.data['product']);
        }
        Get.back(closeOverlays: true);
        Get.back(closeOverlays: true);
        Get.to(() => ProductScreen(_products[prodIndex]));
        successAlert(response.data['message']);
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  Future<void> editColor(formData, productId) async {
    status = AddProductStatus.Loading;
    update();
    try {
      dio.Response response = await editColorApi(formData);
      if (response.data['success']) {
        final product =
            _products.firstWhere((element) => element['id'] == productId);
        final prodIndex = _products.indexOf(product);
        final color = _products[prodIndex]['colors'].firstWhere(
          (c) => c['id'] == response.data['product']['id'],
          orElse: () => null,
        );
        if (color != null) {
          final colorIndex = _products[prodIndex]['colors'].indexOf(color);
          _products[prodIndex]['colors'][colorIndex] = response.data['product'];
        } else {
          _products[prodIndex]['colors'].add(response.data['product']);
        }
        Get.back(closeOverlays: true);
        Get.back(closeOverlays: true);
        Get.to(() => ProductScreen(_products[prodIndex]));
        successAlert(response.data['message']);
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
      print({'object': e});
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  Future<void> removeColor(productId, colorId) async {
    status = AddProductStatus.Loading;
    update();
    try {
      final Map data = {
        'id': colorId,
      };
      dio.Response response = await removeColorApi(data);
      if (response.data['success']) {
        final product =
            _products.firstWhere((element) => element['id'] == productId);
        final prodIndex = _products.indexOf(product);
        final color = _products[prodIndex]['colors']
            .firstWhere((c) => c['id'] == colorId);
        _products[prodIndex]['colors'].remove(color);
        Get.back(closeOverlays: true);
        Get.to(() => ProductScreen(_products[prodIndex]));
        successAlert(response.data['message']);
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      status = AddProductStatus.Initial;
      update();
    }
  }

  bool _removing = false;
  bool get removingImageLoading => _removing;
  Future<bool> removeColorImage(imageId, productId, colorId) async {
    _removing = true;
    update();
    try {
      Map data = {
        'color_id': colorId,
        'image_id': imageId,
      };
      dio.Response response = await removeColorImageApi(data);
      if (response.data['success']) {
        final product = _products.firstWhere((p) => p['id'] == productId);
        final prodIndex = _products.indexOf(product);
        final color = _products[prodIndex]['colors']
            .firstWhere((c) => c['id'] == colorId);
        final colorIndex = _products[prodIndex]['colors'].indexOf(color);
        _products[prodIndex]['colors'][colorIndex]['pictures'] =
            response.data['product']['pictures'];
        successAlert(response.data['message']);

        return true;
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      update();
      _removing = false;
    }
    return false;
  }

  bool _setting = false;
  bool get settingImageLoading => _setting;
  Future<bool> setImageAsMain(imageId, product, color) async {
    _setting = true;
    update();
    try {
      final prodIndex = _products.indexOf(product);
      final colorIndex = _products[prodIndex]['colors'].indexOf(color);
      Map data = {
        'color_id': color['id'],
        'image_id': imageId,
      };
      dio.Response response = await setImageAsMainApi(data);
      if (response.data['success']) {
        _products[prodIndex]['colors'][colorIndex]['pictures'] =
            response.data['product']['pictures'];
        return true;
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      _setting = false;
      update();
    }
    return false;
  }
  //  shop

  ShopEditStatus shopEditStatus = ShopEditStatus.Initial;
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
        Get.back(closeOverlays: true);
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
