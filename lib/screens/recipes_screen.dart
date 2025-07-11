import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/screens/plan_screen.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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

  void _addRecipe() {
    _printRecipeBox();
    final title = _titleController.text.trim();
    final description = _descController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Введите название")));
    }
    if (title.isNotEmpty) {
      final uuid = Uuid();
      final id = uuid.v4();
      ;
      final recipe = Recipe(id, title, description);
      ref.read(recipeProvider.notifier).addOrReplaceRecipe(recipe);
      _titleController.clear();
      _descController.clear();
    }
  }

  void _removeRecipe(Recipe recipe) =>
      ref.read(recipeProvider.notifier).removeRecipe(recipe);

  void _navigateToPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlanScreen()),
    );
  }

  void _navigateToWeekPlan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WeekPlanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои рецепты'),
        actions: [
          IconButton(
            onPressed: _navigateToPlan,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _RecipeInput(
              titleController: _titleController,
              descController: _descController,
              onAdd: _addRecipe,
              onOpenWeekPlan: _navigateToWeekPlan,
            ),
          ),
          Expanded(
            child: _RecipeList(recipes: recipes, onRemove: _removeRecipe),
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

class _RecipeInput extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final VoidCallback onAdd;
  final VoidCallback onOpenWeekPlan;

  const _RecipeInput({
    required this.titleController,
    required this.descController,
    required this.onAdd,
    required this.onOpenWeekPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Введите название'),
              ),
            ),
            IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
            IconButton(onPressed: onOpenWeekPlan, icon: Icon(Icons.list_alt)),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: descController,
                decoration: const InputDecoration(hintText: "Введите описание"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecipeList extends StatelessWidget {
  final void Function(Recipe) onRemove;
  final Set<Recipe> recipes;

  const _RecipeList({required this.recipes, required this.onRemove});

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
          trailing: IconButton(
            onPressed: () => onRemove(recipe),
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
