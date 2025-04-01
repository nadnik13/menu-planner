import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_recipe_app/providers/plan_state_providers.dart';
import 'package:my_recipe_app/providers/recipe_provider.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../providers/meal_plan_provider.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedRecipe = ref.watch(selectedRecipeProvider);
    final formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('План')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
            'Дата: $formattedDate',
            style: const TextStyle(fontSize: 16)
                )
                ),
                IconButton(onPressed: () async {
                  final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: selectedDate.subtract(
                          const Duration(days: 60)),
                      lastDate: selectedDate.add(const Duration(days: 305)));
                  if (picked != null) {
                    ref
                        .read(selectedDateProvider.notifier)
                        .state = picked;
                  }
                },
              icon: Icon(Icons.edit))
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<Recipe>(
              value: selectedRecipe,
              hint: const Text("Выбрать рецепт"),
              isExpanded: true,
              items:
                  recipes.map((recipe) {
                    return DropdownMenuItem<Recipe>(
                      value: recipe,
                      child: Text(recipe.title),
                    );
                  }).toList(),
              onChanged: (value) {
                ref.read(selectedRecipeProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedRecipe != null) {
                  final plan = MealPlan(
                    date: selectedDate,
                    recipe: selectedRecipe!,
                  );
                  ref
                      .read(mealPlanProvider.notifier)
                      .addPlan(selectedDate, plan);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('План добавлен')),
                  );
                }
              },
              child: const Text('Сохранить план'),
            ),
          ],
        ),
      ),
    );
  }
}
