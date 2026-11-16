import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/features/favorites/controllers/favorite_controller.dart';
import 'package:recipe/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe/features/recipe_details/screens/recipe_details_screen.dart';

class FavoritesScreen extends GetView<FavoriteController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: Obx(() {
        if (controller.favourites.isEmpty) {
          return const Center(child: Text('No Favorite Recipe Yet'));
        }

        return ListView.builder(
          itemCount: controller.favourites.length,
          itemBuilder: (context, index) {
            final recipe = controller.favourites[index];

            return ListTile(
              onTap: () {
                final RecipeDetailsController detailsController =
                    Get.find<RecipeDetailsController>();

                detailsController.loadRecipe(recipe.id);
                Get.to(() => const RecipeDetailsScreen());
              },

              leading: Image.network(
                recipe.imageUrl,
                width: 60,
                fit: BoxFit.cover,
              ),
              title: Text(recipe.name),
              subtitle: Text(recipe.category),
              trailing: IconButton(
                onPressed: () {
                  controller.removeFavorite(recipe.id);
                },
                icon: const Icon(Icons.favorite, color: Colors.red),
              ),
            );
          },
        );
      }),
    );
  }
}
