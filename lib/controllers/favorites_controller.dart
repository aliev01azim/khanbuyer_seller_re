import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:khanbuer_seller_re/helpers/alerts.dart';
import 'package:khanbuer_seller_re/helpers/api_services.dart';

class FavoritesController extends GetxController {
  List _favorites = [];
  List _favoritesIds = [];

  List get favorites => _favorites;

  List get favoritesIds => _favoritesIds;

  Future<void> getFavorites() async {
    try {
      dio.Response response = await getFavoritesApi();
      final result = response.data;
      _favorites = result;
      _favoritesIds = result.map((r) => r['id']).toList();
    } catch (error) {
      errorAlert(error);
    } finally {
      update();
    }
  }

  Future<void> addToFavorites(product) async {
    try {
      final prevFavorites = _favorites;
      final prevFavoritesIds = _favoritesIds;
      _favorites = [...prevFavorites, product];
      _favoritesIds = [...prevFavoritesIds, product['id']];
      update();
      dio.Response response = await addToFavoritesApi(product['id']);
      final result = response.data;

      if (!result.containsKey('success') ||
          result.containsKey('success') && !result['success']) {
        _favorites = prevFavorites;
        _favoritesIds = prevFavoritesIds;
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      update();
    }
  }

  Future<void> removeFavorite(productId) async {
    try {
      final prevFavorites = _favorites;
      final prevFavoritesIds = _favoritesIds;
      _favorites.removeWhere((f) => f['id'] == productId);
      _favoritesIds.removeWhere((fId) => fId == productId);
      update();

      dio.Response response = await removeFavoriteApi(productId);
      final result = response.data;
      bool success = result.containsKey('success') && result['success'];

      if (!success) {
        _favorites = prevFavorites;
        _favoritesIds = prevFavoritesIds;
        errorAlert(result['message']);
      }
    } catch (error) {
      errorAlert(error);
    } finally {
      update();
    }
  }
}
