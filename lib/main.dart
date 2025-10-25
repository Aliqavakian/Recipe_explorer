import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/recipe_bloc.dart';
import '../repository//recipe_repository.dart';
import 'screens/list_screen.dart';


void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => RecipeRepository(),
      child: BlocProvider(
        create: (context) => RecipeBloc(repository: context.read<RecipeRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Recipe Explorer',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const ListScreen(),
        ),
      ),
    );
  }
}
