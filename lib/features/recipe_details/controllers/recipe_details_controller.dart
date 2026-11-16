import 'package:get/get.dart';
import 'package:recipe/data/models/recipe_model.dart';
import 'package:recipe/data/services/recipe_api_service.dart';

class RecipeDetailsController extends GetxController {
  final RecipeApiService _recipeApiService = Get.find<RecipeApiService>();

  final Rxn<RecipeModel> recipe = Rxn<RecipeModel>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> loadRecipe(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      recipe.value = null;

      final result = await _recipeApiService.getRecipeById(id);

      if (result == null) {
        errorMessage.value = 'Recipe Not Found';
        return;
      }

      recipe.value = result;
    } on RecipeApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Something went Wrong. Please Try Again';
    } finally {
      isLoading.value = false;
    }
  }
}
