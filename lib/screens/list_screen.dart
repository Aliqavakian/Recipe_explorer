import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../widgets/recipe_item.dart';
import 'details_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Dessert', 'Main Course'];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(RecipeLoadInitial());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RecipeBloc>().add(RecipeLoadMore());
    }
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    context.read<RecipeBloc>().add(
        RecipeCategoryChanged(category == 'All' ? '' : category));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search recipes...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  context.read<RecipeBloc>().add(RecipeSearchChanged(value)),
            ),
          ),
          // Category filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) => _onCategorySelected(category),
                  ),
                );
              },
            ),
          ),
          // Recipe list
          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state.loading && state.recipes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.recipes.isEmpty) {
                  return const Center(child: Text('No recipes found.'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                  state.recipes.length + (state.hasReachedEnd ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.recipes.length) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final recipe = state.recipes[index];
                    return GestureDetector(
                      onTap: () {
                        context.read<RecipeBloc>().add(RecipeSelect(recipe.id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DetailsScreen()),
                        );
                      },
                      child: RecipeItem(
                        recipe: recipe,
                        onFavoriteToggle: () {
                          context
                              .read<RecipeBloc>()
                              .add(RecipeToggleFavorite(recipe.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
