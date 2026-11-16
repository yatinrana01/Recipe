import 'package:get/get.dart';
import 'package:recipe/data/models/recipe_model.dart';
import 'package:recipe/data/services/recipe_api_service.dart';

class HomeController extends GetxController {
  final RecipeApiService _recipeApiService = Get.find<RecipeApiService>();
  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxnString errorMessage = RxnString();
  final RxString searchQuery = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxnString selectedCategory = RxnString();
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreRecipes = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
    loadCategories();
  }

  Future<void> loadRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _recipeApiService.searchRecipe('salmon');
      recipes.assignAll(result);
    } on RecipeApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went Wrong. Please Try again';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchRecipes(String query) async {
    searchQuery.value = query;
    selectedCategory.value = null;
    await loadRecipesByQuery(query);
  }

  Future<void> loadRecipesByQuery(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _recipeApiService.searchRecipe(query);
      recipes.assignAll(result);
    } on RecipeApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please Try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final result = await _recipeApiService.getCategories();
      categories.assignAll(result);
    } on RecipeApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Unable to Load Categories';
    }
  }

  Future<void> filterByCategories(String category) async {
    selectedCategory.value = category;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _recipeApiService.getRecipeByCategory(category);

      recipes.assignAll(result);
    } on RecipeApiException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Something Went Wrong. Please Try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearCategories() {
    selectedCategory.value = null;
    searchQuery.value = '';
    loadRecipes();
  }

  Future<void> retryLastRequest() async {
    if (selectedCategory.value != null) {
      await filterByCategories(selectedCategory.value!);
    } else if (searchQuery.value.isNotEmpty) {
      await loadRecipesByQuery(searchQuery.value);
    } else {
      await loadRecipes();
    }
  }

  Future<void> loadMoreRecipes() async {
    if (isLoadingMore.value || !hasMoreRecipes.value) return;

    try {
      isLoadingMore.value = true;
      final existingIds = recipes.map((recipe) => recipe.id).toSet();
      final targetCount = recipes.length + 5;
      int attempt = 0;

      while (recipes.length < targetCount && attempt < 10) {
        attempt++;
        final result = await _recipeApiService.getRandomRecipe();

        if (result.isEmpty) {
          hasMoreRecipes.value = false;
          break;
        }

        for (final recipe in result) {
          if (existingIds.add(recipe.id)) {
            recipes.add(recipe);
          }
        }
      }
    } catch (e) {
      throw RecipeApiException(e.toString());
    }
  }
}
