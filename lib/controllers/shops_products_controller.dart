// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';

enum Status { Initial, Loading, Error }
Map initialFilters = {
  'shop_id': null,
  'category_id': [],
  'seasonality': null,
  'size': null,
};

class ShopsProductsController extends GetxController {
  List _products = [];
  int _pageIndex = 1;
  Status _status = Status.Initial;
  List _shops = [];
  List _categories = [];

  Map _filters = initialFilters;

  List get products => _products;

  Status get status => _status;

  Map get filters => _filters;

  List get shops => _shops;

  List get categories => _categories;

  Future<void> getProducts({
    bool loadMore = false,
    bool filter = false,
  }) async {
    print('asda');
    if (loadMore) {
      _pageIndex = _pageIndex + 1;
      _status = Status.Loading;
      update();
    } else if (filter) {
      _pageIndex = 1;
      _status = Status.Loading;
      _products = [];
      update();
    } else {
      _pageIndex = 1;
    }

    dynamic params = [
      'per-page=20',
      'page=$_pageIndex',
    ];

    _filters.forEach((key, value) {
      if (value is List) {
        for (var element in value) {
          if (key == 'category_id') {
            params.add('ProductSearch[category_ids][]=$element');
          } else {
            params.add('ProductSearch[$key]=$element');
          }
        }
      } else {
        if (value != null) {
          if (key == 'size') {
            params.add('ProductSearch[$value]=56');
          } else {
            params.add('ProductSearch[$key]=$value');
          }
        }
      }
    });

    params.removeWhere((String element) => element.endsWith('=null'));

    params = params.join('&');

    try {
      dio.Response response = await getProductsApi();
      final result = response.data;
      if (loadMore) {
        if (_products[_products.length - 1]['id'] !=
            result[result.length - 1]['id']) {
          _products = [..._products, ...result];
        } else {
          _pageIndex = _pageIndex - 1;
        }
      } else {
        _products = result;
      }
      print('products : $result');
      _status = Status.Initial;
    } on dio.DioError catch (error) {
      _status = Status.Error;
      errorAlert(error.response!.data);
    } catch (error) {
      _status = Status.Error;
      errorAlert(error);
    } finally {
      update();
    }
  }

  void setFilter({filters}) {
    _filters = filters;
    update();

    getProducts(filter: true);
  }

  void resetFilters() {
    initialFilters.forEach((key, value) {
      if (value is List) {
        initialFilters[key] = [];
      } else {
        initialFilters[key] = null;
      }
    });
    _filters = initialFilters;
  }

  void removeFilter(String value) {
    final keyValue = value.split(':');
    if (_filters[keyValue[0]] is List) {
      _filters[keyValue[0]]
          .removeWhere((item) => item.toString() == keyValue[1].toString());
    } else {
      _filters[keyValue[0]] = null;
    }
    update();

    getProducts(filter: true);
  }

  Future<void> getCategories() async {
    Response response = await getCategoriesApi();
    List categories = response.body
        .where((c) => c['parent_id'] != null)
        .map((c) => {
              'id': c['id'],
              'title': c['title'],
            })
        .toList();
    _categories = categories;
    print('categories : $_categories');
  }

  void removeProductFromList(id) {
    _products.removeWhere((element) => element['id'] == id);
    update();
  }
}
