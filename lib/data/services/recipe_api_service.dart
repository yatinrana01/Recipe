import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/data/models/recipe_model.dart';

class RecipeApiException implements Exception {
  final String message;
  const RecipeApiException(this.message);
  @override
  String toString() => message;
}

class RecipeApiService extends GetxService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  final http.Client _client;
  final bool _ownClient;

  RecipeApiService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownClient = client == null;

  Future<List<RecipeModel>> searchRecipe(String query) async {
    final searchTerm = query.trim();
    if (searchTerm.isEmpty) {
      return [];
    }

    final uri = Uri.parse('$baseUrl/search.php')
        .replace(queryParameters: {'s': searchTerm});

    return _getRecipe(uri);
  }

  Future<RecipeModel?> getRecipeById(String id) async {
    final recipeId = id.trim();

    if (recipeId.isEmpty) {
      throw const RecipeApiException('Recipe ID can not be Empty');
    }

    final uri = Uri.parse('$baseUrl/lookup.php')
        .replace(queryParameters: {'i': recipeId});

    final recipes = await _getRecipe(uri);

    return recipes.isEmpty ? null : recipes.first;
  }

  Future<List<String>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories.php');
    final data = await _getJson(uri);
    final categories = data['categories'];

    if (categories == null) {
      return [];
    }

    if (categories is! List) {
      throw const RecipeApiException('Invalid Categories data returned by API');
    }

    try {
      return categories
          .map((category) {
            if (category is! Map<String, dynamic>) {
              throw const RecipeApiException(
                'Invalid Category Object in API Response',
              );
            }
            return category['strCategory'] as String? ?? '';
          })
          .where((name) => name.trim().isNotEmpty)
          .toList();
    } on RecipeApiException {
      rethrow;
    } catch (_) {
      throw const RecipeApiException('Unable to Parse recipe Category');
    }
  }

  Future<List<RecipeModel>> _getRecipe(Uri uri) async {
    final data = await _getJson(uri);
    final meals = data['meals'];

    if (meals == null) {
      return [];
    }

    if (meals is! List) {
      throw const RecipeApiException('Invalid Recipe Data returen by the API');
    }
    try {
      return meals.map((meal) {
        if (meal is! Map<String, dynamic>) {
          throw const RecipeApiException(
            'Invalid Recipe Object in API response',
          );
        }
        return RecipeModel.fromJson(meal);
      }).toList();
    } on RecipeApiException {
      rethrow;
    } catch (_) {
      throw const RecipeApiException('Unable to parse recipe information.');
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw RecipeApiException(
          'API Response Failed With Status: ${response.statusCode}',
        );
      }

      final dynamic decodedData;

      try {
        decodedData = jsonDecode(response.body);
      } on FormatException {
        throw const RecipeApiException('API Returned Invalid json');
      }

      if (decodedData is! Map<String, dynamic>) {
        throw const RecipeApiException('UnExpected API response format');
      }
      return decodedData;
    } on RecipeApiException {
      rethrow;
    } on http.ClientException {
      throw const RecipeApiException('Unable to Connec to API.');
    } catch (_) {
      throw const RecipeApiException('An Unexpected API error occured');
    }
  }

  Future<List<RecipeModel>> getRecipeByCategory(String category) async {
    final trimmmedCategory = category.trim();

    if (trimmmedCategory.isEmpty) {
      return [];
    }

    final uri = Uri.parse('$baseUrl/filter.php')
        .replace(queryParameters: {'c': trimmmedCategory});

    return _getRecipe(uri);
  }

  Future<List<RecipeModel>> getRandomRecipe() async {
    final uri = Uri.parse('$baseUrl/random.php');

    return _getRecipe(uri);
  }

  @override
  void onClose() {
    if (_ownClient) {
      _client.close();
    }

    super.onClose();
  }

  void dispose() {
    if (_ownClient) {
      _client.close();
    }
  }
}
