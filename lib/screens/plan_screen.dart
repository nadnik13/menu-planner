import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/plan_state_providers.dart';
import '../models/recipe.dart';
import '../providers/meal_plan_provider.dart';
import '../providers/recipe/recipe_provider.dart';
import '../widgets/save_button.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedRecipe = ref.watch(selectedRecipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('План')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _DatePickerRow(
              selectedDate: selectedDate,
              onDateChanged: (value) {
                ref.read(selectedDateProvider.notifier).update(value);
              },
            ),
            const SizedBox(height: 16),
            _RecipeDropdown(
              selectedRecipe: selectedRecipe,
              onSelectedRecipe: (recipe) {
                ref.read(selectedRecipeProvider.notifier).state = recipe;
              },
            ),
            const SizedBox(height: 16),
            SaveButton(
              selectedDate: selectedDate,
              isActive: selectedRecipe != null,
              onSave: () {
                ref
                    .read(mealPlanProvider.notifier)
                    .saveRecipe(selectedDate, selectedRecipe);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('План добавлен')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DatePickerRow({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate.dateKey;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Дата: $formattedDate',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: selectedDate.subtract(const Duration(days: 60)),
              lastDate: selectedDate.add(const Duration(days: 305)),
            );
            if (picked != null) {
              onDateChanged(picked);
            }
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}

class _RecipeDropdown extends ConsumerWidget {
  final Recipe? selectedRecipe;
  final ValueChanged<Recipe?> onSelectedRecipe;

  const _RecipeDropdown({
    required this.selectedRecipe,
    required this.onSelectedRecipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeProvider);
    return DropdownButton<Recipe>(
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
      onChanged: onSelectedRecipe,
    );
  }
}
