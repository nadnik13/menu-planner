import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/providers/meal/meal_interactor.dart';
import 'package:my_recipe_app/providers/recipe/recipe_interactor.dart';
import 'package:my_recipe_app/screens/recipe_editor.dart';
import '../core/logger.dart';
import '../models/recipe.dart';
import '../providers/recipe/recipe_notifier.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  void _printRecipeBox() {
    final box = Hive.box<Recipe>('recipeBox');
    logger.d('📦 Всего рецептов: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  @override
  void initState() {
    super.initState();
    _printRecipeBox();
  }

  void _removeRecipe(Recipe recipe) {
    ref.watch(recipeInteractorProvider).removeRecipe(recipe);
  }

  void _editRecipe(Recipe? recipe) {
    showDialog(
      context: context,
      builder: (context) => RecipeEditor(recipe: recipe),
    );
  }

  void _addMeal(Recipe recipe) {
    ref.read(mealInteractorProvider).addMealByRecipe(recipe);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Блюдо ${recipe.title} добавлено')));
    logger.d('Добавлено блюдо ${recipe.title}');
  }

  @override
  Widget build(BuildContext context) {
    logger.d("_RecipeScreenState.build");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все рецепты'),
      ),
      body: Column(
        children: [
          Expanded(
            child: //Text("_RecipeList")
                _RecipeList(
              onRemove: _removeRecipe,
              onAdd: _addMeal,
              onEdit: _editRecipe,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Hive.box<Recipe>('recipeBox').clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('База рецептов очищена')),
              );
              _printRecipeBox();
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _editRecipe(null),
        tooltip: "Добавить рецепт",
      child: Icon(Icons.add),
    ));
  }
}

class _RecipeList extends ConsumerWidget {
  final void Function(Recipe) onRemove;
  final void Function(Recipe) onEdit;
  final void Function(Recipe) onAdd;

  const _RecipeList({
    required this.onRemove,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeProvider);
    if (recipes.isEmpty) {
      return const Center(child: Text('Нет добавленных рецептов'));
    }
    final recipesList = recipes.toList();
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipesList[index];

        return ListTile(
          title: Text(recipe.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onEdit(recipe),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => onRemove(recipe),
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () => onAdd(recipe),
                icon: const Icon(Icons.edit_calendar_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
