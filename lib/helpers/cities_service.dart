import './cities_data.dart';

class CitiesService {
  static List getCitiesSuggestions(String query, cities) {
    List matches = [];

    if (cities.length != 0) {
      matches.addAll(cities);
    } else {
      for (var c in CitiesData.countries) {
        matches.addAll(c['cities']);
      }
    }

    matches.retainWhere(
        (s) => s['city'].toLowerCase().contains(query.toLowerCase()));

    return matches;
  }

  static List<Map> getCountriesSuggestions(String query) {
    List<Map> matches = [];

    matches.addAll(CitiesData.countries);

    matches.retainWhere(
        (c) => c['name'].toLowerCase().contains(query.toLowerCase()));

    return matches;
  }
}

class BrandsService {
  static List getSuggestions(String query, List brands) {
    List matches = [];

    matches.addAll(brands);

    matches.retainWhere(
        (s) => s['name'].toLowerCase().contains(query.toLowerCase()));

    return matches;
  }
}
