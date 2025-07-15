import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/providers/meal_provider.dart';
import 'package:my_recipe_app/screens/recipes_screen.dart';
import 'package:my_recipe_app/screens/week_plan_screen.dart';
import '../core/logger.dart';
import '../models/meal.dart';

class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  ConsumerState<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen> {
  void _printMealBox() {
    final box = Hive.box<Meal>('mealBox');
    logger.d('📦 Всего блюд: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  @override
  void initState() {
    super.initState();
    _printMealBox();
  }

  void _removeRecipe(Meal meal) =>
      ref.read(mealProvider.notifier).removeMeal(meal);

  void _navigateToRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeScreen()),
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
    final meals = ref.watch(mealProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои блюда'),
        actions: [
          IconButton(
            onPressed: _navigateToRecipes,
            icon: const Icon(Icons.book),
            tooltip: "Кулинарная книга",
          ),
          IconButton(
            onPressed: _navigateToWeekPlan,
            icon: Icon(Icons.list_alt),
            tooltip: "Недельный план",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: //Text("_RecipeList")
                _MealList(
              meals: meals,
              onRemove: _removeRecipe,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Hive.box<Meal>('mealBox').clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Все блюда удалены')),
              );
              _printMealBox();
            },
            icon: Icon(Icons.delete_forever),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRecipes,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _MealList extends StatelessWidget {
  final void Function(Meal) onRemove;
  final Set<Meal> meals;

  const _MealList({
    required this.meals,
    required this.onRemove
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const Center(child: Text('Нет добавленных блюд'));
    }
    final mealsList = meals.toList();
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = mealsList[index];

        return ListTile(
          title: Text(meal.title),
          subtitle: Text(
            'Порций: ${meal.addedCntPortion} (план ${meal.usedCntPortion})',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onRemove(meal),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}
