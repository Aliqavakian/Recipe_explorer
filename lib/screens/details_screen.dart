import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_state.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeBloc>().state;
    final recipe = state.selected;

    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe Details')),
        body: const Center(child: Text('No recipe selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${recipe.category}',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
