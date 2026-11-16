import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:recipe/features/recipe_details/controllers/recipe_details_controller.dart';

class RecipeDetailsScreen extends GetView<RecipeDetailsController> {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Details'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: Get.back, child: Text('Go Back')),
                ],
              ),
            ),
          );
        }

        final recipe = controller.recipe.value;

        if (recipe == null) {
          return const Center(child: Text('No Recipe Available'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                recipe.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 250,
                    child: Center(child: Icon(Icons.restaurant, size: 60)),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${recipe.category} * ${recipe.area}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    ...List.generate(recipe.ingredients.length, (index) {
                      final measurement = index < recipe.measurements.length
                          ? recipe.measurements[index]
                          : '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(
                              child: Text(
                                measurement.isEmpty
                                    ? recipe.ingredients[index]
                                    : '$measurement ${recipe.ingredients[index]}',
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      recipe.instructions,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                    if (recipe.sourceUrl.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      SelectableText(
                        'Source: ${recipe.sourceUrl}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
