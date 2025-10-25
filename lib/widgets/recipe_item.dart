import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onFavoriteToggle;

  const RecipeItem({super.key, required this.recipe, this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(recipe.title),
        subtitle: Text(recipe.category),
        trailing: IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.star : Icons.star_border,
            color: recipe.isFavorite ? Colors.amber : null,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}
