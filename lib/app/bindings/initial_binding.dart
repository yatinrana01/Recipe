import 'package:get/get.dart';
import 'package:recipe/data/services/recipe_api_service.dart';
import 'package:recipe/features/favorites/controllers/favorite_controller.dart';
import 'package:recipe/features/home/controllers/home_controller.dart';
import 'package:recipe/features/recipe_details/controllers/recipe_details_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RecipeApiService>(RecipeApiService(), permanent: true);
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    Get.lazyPut<RecipeDetailsController>(
      () => RecipeDetailsController(),
      fenix: true,
    );
  }
}
