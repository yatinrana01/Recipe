import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/data/models/recipe_model.dart';

void main() {
  test('parses recipe fields and ingredients correctly', () {
    final recipe = RecipeModel.fromJson({
      'idMeal': '52795',
      'strMeal': 'Chicken Handi',
      'strMealThumb': 'https://example.com/chicken.jpg',
      'strCategory': 'Chicken',
      'strArea': 'Indian',
      'strInstructions': 'Cook the chicken.',
      'strSource': null,
      'strIngredient1': 'Chicken',
      'strMeasure1': '1.2 kg',
      'strIngredient2': 'Onion',
      'strMeasure2': '2',
      'strIngredient3': ' ',
      'strMeasure3': ' ',
    });

    expect(recipe.id, '52795');
    expect(recipe.name, 'Chicken Handi');
    expect(recipe.sourceUrl, '');
    expect(recipe.ingredients, ['Chicken', 'Onion']);
    expect(recipe.measurements, ['1.2 kg', '2']);
  });

  test('handles missing fields', () {
    final recipe = RecipeModel.fromJson({});

    expect(recipe.id, '');
    expect(recipe.name, '');
    expect(recipe.ingredients, isEmpty);
    expect(recipe.measurements, isEmpty);
  });

  test('serializes and restores a recipe', () {
    final original = RecipeModel.fromJson({
      'idMeal': '52795',
      'strMeal': 'Chicken Handi',
      'strIngredient1': 'Chicken',
      'strMeasure1': '1 kg',
    });

    final restored = RecipeModel.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.name, original.name);
    expect(restored.ingredients, original.ingredients);
    expect(restored.measurements, original.measurements);
  });
}
