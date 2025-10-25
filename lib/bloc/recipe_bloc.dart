import 'package:flutter_bloc/flutter_bloc.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';
import '../repository//recipe_repository.dart';
import '../models/recipe.dart';


class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;
  static const int _pageSize = 5;

  RecipeBloc({required this.repository}) : super(const RecipeState()) {
    on<RecipeLoadInitial>(_onInitial);
    on<RecipeLoadMore>(_onLoadMore);
    on<RecipeSearchChanged>(_onSearchChanged);
    on<RecipeCategoryChanged>(_onCategoryChanged);
    on<RecipeToggleFavorite>(_onToggleFavorite);
    on<RecipeSelect>(_onSelect);
  }

  Future<void> _onInitial(RecipeLoadInitial event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(loading: true, recipes: [], hasReachedEnd: false));
    final fetched = await repository.fetchRecipes(limit: _pageSize, offset: 0);
    emit(state.copyWith(recipes: fetched, loading: false, hasReachedEnd: fetched.length < _pageSize));
  }

  Future<void> _onLoadMore(RecipeLoadMore event, Emitter<RecipeState> emit) async {
    if (state.loading || state.hasReachedEnd) return;
    emit(state.copyWith(loading: true));
    final offset = state.recipes.length;
    final fetched = await repository.fetchRecipes(
      limit: _pageSize,
      offset: offset,
      search: state.searchQuery,
      category: state.category,
    );
    emit(state.copyWith(
      recipes: List.from(state.recipes)..addAll(fetched),
      loading: false,
      hasReachedEnd: fetched.length < _pageSize,
    ));
  }

  Future<void> _onSearchChanged(RecipeSearchChanged event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(searchQuery: event.query, loading: true, recipes: [], hasReachedEnd: false));
    final fetched = await repository.fetchRecipes(limit: _pageSize, offset: 0, search: event.query, category: state.category);
    emit(state.copyWith(recipes: fetched, loading: false, hasReachedEnd: fetched.length < _pageSize));
  }

  Future<void> _onCategoryChanged(RecipeCategoryChanged event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(category: event.category, loading: true, recipes: [], hasReachedEnd: false));
    final fetched = await repository.fetchRecipes(limit: _pageSize, offset: 0, search: state.searchQuery, category: event.category);
    emit(state.copyWith(recipes: fetched, loading: false, hasReachedEnd: fetched.length < _pageSize));
  }

  Future<void> _onToggleFavorite(RecipeToggleFavorite event, Emitter<RecipeState> emit) async {
    final idx = state.recipes.indexWhere((r) => r.id == event.recipeId);
    if (idx == -1) return;
    final updated = List<Recipe>.from(state.recipes);
    updated[idx] = updated[idx].copyWith(isFavorite: !updated[idx].isFavorite);
    await repository.saveFavorites(updated.where((r) => r.isFavorite).map((r) => r.id).toList());
    emit(state.copyWith(recipes: updated));
  }

  Future<void> _onSelect(RecipeSelect event, Emitter<RecipeState> emit) async {
    final recipe = await repository.getById(event.recipeId);
    emit(state.copyWith(selected: recipe));
  }
}
