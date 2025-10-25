
import 'package:recipe_explorer/models/recipe.dart';

class RecipeRepository {
  final List<Recipe> _recipes = List.generate(
    20,
        (index) => Recipe(
      id: index,
      title: 'Recipe $index',
      description: 'This is the description for Recipe $index',
      category: index % 2 == 0 ? 'Dessert' : 'Main Course',
    ),
  );

  Future<List<Recipe>> fetchRecipes({
    int limit = 5,
    int offset = 0,
    String? search,
    String? category,
  }) async {
    List<Recipe> filtered = _recipes;

    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((r) => r.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((r) => r.category == category).toList();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return filtered.skip(offset).take(limit).toList();
  }

  Future<void> saveFavorites(List<int> favoriteIds) async {
    // Optional: persist favorites
  }

  Future<Recipe> getById(int id) async {
    return _recipes.firstWhere((r) => r.id == id);
  }
}
