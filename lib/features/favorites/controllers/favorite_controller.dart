import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe/data/models/recipe_model.dart';

class FavoriteController extends GetxController {
  final GetStorage _storage = GetStorage();

  final RxList<RecipeModel> favourites = <RecipeModel>[].obs;

  static const String _storageKey = 'favorite_recipes';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    final storedData = _storage.read<List>(_storageKey);
    if (storedData == null) return;

    favourites.assignAll(storedData.map((item) => RecipeModel.fromJson(item)));
  }

  void addFavorite(RecipeModel recipe) {
    if (isFavorite(recipe.id)) return;

    favourites.add(recipe);
    _saveFavorites();
  }

  void removeFavorite(String id) {
    favourites.removeWhere((recipe) => recipe.id == id);
    _saveFavorites();
  }

  bool isFavorite(String id) {
    return favourites.any((recipe) => recipe.id == id);
  }

  void _saveFavorites() {
    final data = favourites.map((recipe) => recipe.toJson()).toList();
    _storage.write(_storageKey, data);
  }
}
