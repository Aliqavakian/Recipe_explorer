abstract class RecipeEvent {}

class RecipeLoadInitial extends RecipeEvent {}

class RecipeLoadMore extends RecipeEvent {}

class RecipeSearchChanged extends RecipeEvent {
  final String query;
  RecipeSearchChanged(this.query);
}

class RecipeCategoryChanged extends RecipeEvent {
  final String category;
  RecipeCategoryChanged(this.category);
}

class RecipeToggleFavorite extends RecipeEvent {
  final int recipeId;
  RecipeToggleFavorite(this.recipeId);
}

class RecipeSelect extends RecipeEvent {
  final int recipeId;
  RecipeSelect(this.recipeId);
}
