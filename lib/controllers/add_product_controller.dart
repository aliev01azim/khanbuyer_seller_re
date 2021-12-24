import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/add_product_screen/widgets/add_product_form_next.dart';
import 'package:khanbuer_seller_re/screens/drawers_screens/my_shop_screen/my_shop_screen.dart';

// ignore: constant_identifier_names
enum AddProductStatus { Initial, Loading }

class AddProductController extends GetxController {
  AddProductStatus _addProductStatus = AddProductStatus.Initial;
  List _shops = [];
  List _categories = [];
  final List<dynamic> _parentCategories = [];
  List _colors = [];
  final List<dynamic> _categoryTitles = [];
  final List<dynamic> _categoryValues = [];
  List get categoryValues => _categoryValues;
  String get categoryTitles =>
      _categoryTitles.isEmpty ? 'Не выбрано' : _categoryTitles.join(' - ');
  AddProductStatus get addProductStatus => _addProductStatus;

  List get shops => _shops;

  List get categories => _categories;
  List<dynamic> get parentCategories => _parentCategories;

  List get colors => _colors;

  Future<void> getSellerShops() async {
    try {
      dio.Response response = await getSellerShopsApi();
      final result = response.data;

      // List shops = [];
      // result.forEach((shop) {
      //   shops.add((
      //     value: shop['id'],
      //     title: shop['name'],
      //   ));
      // });
      _shops = shops;
    } catch (e) {
      errorAlert(e);
    } finally {
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

  Future<void> getColors() async {
    try {
      dio.Response response = await getColorsApi();
      final result = response.data;
      _colors = result;
    } catch (e) {
      errorAlert(e);
    } finally {
      update();
    }
  }

  Future<void> addProduct(formData) async {
    try {
      _addProductStatus = AddProductStatus.Loading;
      update();
      dio.Response response = await addProductApi(formData);
      if (response.data['success']) {
        successAlert('Продукт добавлен!');
        final Map product = response.data['product'] ?? {};
        await Get.off(() => MyShopScreen(), arguments: {'product': product});
        print(product);
      } else {
        errorAlert(response);
      }
    } catch (e) {
      errorAlert(e);
    } finally {
      _addProductStatus = AddProductStatus.Initial;
      update();
    }
  }

  void addCategoryValue(dynamic value, {bool clear = false}) {
    if (clear) _categoryTitles.clear();
    _categoryTitles.add(value['title']);
    _categoryValues.add(value);
    print(_categoryTitles);
    update();
  }
}
