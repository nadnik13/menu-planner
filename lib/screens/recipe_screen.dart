import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/screens/plan_screen.dart';
import 'package:my_recipe_app/screens/week_plan_screen.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Отложенно вызываем загрузку из assets
    Future.microtask(() {
      ref.read(recipeProvider.notifier).loadFromAssets();
    });
  }

  void _addRecipe() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          const SnackBar(content: Text("Введите название"))
      );
    }
    if (text.isNotEmpty) {
      ref.read(recipeProvider.notifier).addRecipe(text);
      _controller.clear();
    }
  }

  void _removeRecipe(Recipe recipe) {
    ref.read(recipeProvider.notifier).removeRecipe(recipe);
  }

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
              controller: _controller,
              onAdd: _addRecipe,
              onOpenWeekPlan: _navigateToWeekPlan,
            ),
          ),
          Expanded(
            child: _RecipeList(recipes: recipes, onRemove: _removeRecipe),
          ),
        ],
      ),
    );
  }
}

class _RecipeInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final VoidCallback onOpenWeekPlan;

  const _RecipeInput({
    required this.controller,
    required this.onAdd,
    required this.onOpenWeekPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Введите рецепт'),
          ),
        ),
        IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
        IconButton(onPressed: onOpenWeekPlan, icon: Icon(Icons.list_alt)),
      ],
    );
  }
}

class _RecipeList extends StatelessWidget {
  final void Function(Recipe) onRemove;
  final List<Recipe> recipes;

  const _RecipeList({required this.recipes, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(child: Text('Нет добавленных рецептов'));
    }
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
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
