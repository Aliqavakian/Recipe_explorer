import '../../models/recipe.dart';

class RecipeState {
  final List<Recipe> recipes;
  final bool loading;
  final bool hasReachedEnd;
  final String searchQuery;
  final String? category;
  final Recipe? selected;

  const RecipeState({
    this.recipes = const [],
    this.loading = false,
    this.hasReachedEnd = false,
    this.searchQuery = '',
    this.category,
    this.selected,
  });

  RecipeState copyWith({
    List<Recipe>? recipes,
    bool? loading,
    bool? hasReachedEnd,
    String? searchQuery,
    String? category,
    Recipe? selected,
  }) {
    return RecipeState(
      recipes: recipes ?? this.recipes,
      loading: loading ?? this.loading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      selected: selected ?? this.selected,
    );
  }
}
