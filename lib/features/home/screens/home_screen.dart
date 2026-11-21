import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe/features/favorites/controllers/favorite_controller.dart';
import 'package:recipe/features/home/controllers/home_controller.dart';
import 'package:recipe/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe/features/recipe_details/screens/recipe_details_screen.dart';
import 'package:recipe/utils/widgets/recipe_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  FavoriteController get _favoriteController => Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find your next meal',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Discover delicious recipes for today.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            _SearchBar(controller: controller),

            const SizedBox(height: 16),
            Obx(() {
              final selectedCategory = controller.selectedCategory.value;

              if (controller.categories.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length + 1,
                  itemBuilder: (context, index) {
                    final isSelected = index == 0
                        ? selectedCategory == null
                        : selectedCategory == controller.categories[index - 1];

                    final category = index == 0
                        ? 'All'
                        : controller.categories[index - 1];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          if (index == 0) {
                            controller.clearCategories();
                          } else {
                            controller.filterByCategories(category);
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.errorMessage.value!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: controller.retryLastRequest,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.recipes.isEmpty) {
                  return const Center(child: Text('No Recipe Found'));
                }

                return GridView.builder(
                  itemCount: controller.recipes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return Obx(
                      () => RecipeCard(
                        recipe: recipe,
                        isFavorite: _favoriteController.isFavorite(recipe.id),
                        onTap: () {
                          final detailsController =
                              Get.find<RecipeDetailsController>();
                          detailsController.loadRecipe(recipe.id);
                          Get.to(() => const RecipeDetailsScreen());
                        },
                        onFavoriteTap: () {
                          if (_favoriteController.isFavorite(recipe.id)) {
                            _favoriteController.removeFavorite(recipe.id);
                          } else {
                            _favoriteController.addFavorite(recipe);
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final HomeController controller;

  const _SearchBar({required this.controller});

  @override
  State<_SearchBar> createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchcontroller = TextEditingController();

  void _search() {
    widget.controller.searchRecipes(_searchcontroller.text);
    FocusScope.of(context).unfocus();
    _searchcontroller.clear();
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchcontroller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _search(),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            if (_searchcontroller.text.trim().isNotEmpty) {
              _search();
            } else {
              Get.snackbar(
                'Invalid Search',
                'Please enter something before search Recipe',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          icon: Icon(Icons.arrow_forward),
          tooltip: 'search',
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
