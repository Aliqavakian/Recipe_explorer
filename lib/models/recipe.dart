class Recipe {
  final int id;
  final String title;
  final String description;
  final String category;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isFavorite = false,
  });

  Recipe copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
