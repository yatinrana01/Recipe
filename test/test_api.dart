import 'package:flutter/foundation.dart';
import 'package:recipe/data/services/recipe_api_service.dart';

Future<void> main() async {
  final apiService = RecipeApiService();
  if (kDebugMode) {
    try {
      final recipes = await apiService.searchRecipe('chicken');

      print('Recipes found: ${recipes.length}');

      for (final recipe in recipes.take(3)) {
        print('Name: ${recipe.name}');
        print('ID: ${recipe.id}');
        print('Category: ${recipe.category}');
        print('Ingredients: ${recipe.ingredients}');
        print('-------------------------------------');
      }

      final recipe = await apiService.getRecipeById('52795');

      print('Lookup result: ${recipe?.name ?? 'Not Found'}');
    } on RecipeApiException catch (e) {
      print('API Error: ${e.message}');
    } finally {
      apiService.dispose();
    }
  }
}
