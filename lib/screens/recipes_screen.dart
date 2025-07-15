import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/screens/meal_plan_screen.dart';
import 'package:my_recipe_app/screens/recipe_editor.dart';
import 'package:my_recipe_app/screens/week_plan_screen.dart';
import 'package:uuid/uuid.dart';
import '../core/logger.dart';
import '../models/recipe.dart';
import '../providers/recipe/recipe_provider.dart';

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

  void _removeRecipe(Recipe recipe) =>
      ref.read(recipeProvider.notifier).removeRecipe(recipe);

  void _editRecipe(Recipe? recipe) {
    showDialog(
      context: context,
      builder: (context) => RecipeEditor(recipe: recipe),
    );
  }

  void _addMeal(Recipe recipe) {
    ref.read(mealProvider.notifier).addMealByRecipe(recipe);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Блюдо добавлено')));
    logger.d('Добавлено блюдо ${recipe.title}');
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кулинарная книга'),
        actions: [
          IconButton(
            onPressed: () => _editRecipe(null),
            icon: const Icon(Icons.add),
            tooltip: "Добавить рецепт",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: //Text("_RecipeList")
                _RecipeList(
              recipes: recipes,
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
    );
  }
}

class _RecipeList extends StatelessWidget {
  final void Function(Recipe) onRemove;
  final void Function(Recipe) onEdit;
  final void Function(Recipe) onAdd;
  final Set<Recipe> recipes;

  const _RecipeList({
    required this.recipes,
    required this.onRemove,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
