import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/features/favorites/controllers/favorite_controller.dart';
import 'package:recipe/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe/features/recipe_details/screens/recipe_details_screen.dart';
import 'package:recipe/utils/widgets/recipe_card.dart';

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

        return GridView.builder(
          itemCount: controller.favourites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final recipe = controller.favourites[index];

            return RecipeCard(
              recipe: recipe,
              isFavorite: true,
              onTap: () {
                final detailsController = Get.find<RecipeDetailsController>();

                detailsController.loadRecipe(recipe.id);
                Get.to(() => const RecipeDetailsScreen());
              },
              onFavoriteTap: () {
                controller.removeFavorite(recipe.id);
              },
            );
          },
        );
      }),
    );
  }
}
