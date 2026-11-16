class RecipeModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final String sourceUrl;
  final List<String> ingredients;
  final List<String> measurements;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.area,
    required this.instructions,
    required this.sourceUrl,
    required this.ingredients,
    required this.measurements,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    final List<String> measurements = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String?)?.trim() ?? '';

      final measurement = (json['strMeasure$i'] as String?)?.trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measurements.add(measurement);
      }
    }

    return RecipeModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal'] as String? ?? '',
      imageUrl: json['strMealThumb'] as String? ?? '',
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      sourceUrl: json['strSource'] as String? ?? '',
      ingredients: ingredients,
      measurements: measurements,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': imageUrl,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strSource': sourceUrl,
    };

    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i];
      json['strMeasure${i + 1}'] = i < measurements.length
          ? measurements[i]
          : '';
    }

    return json;
  }
}
