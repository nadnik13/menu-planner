import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/plan_state_providers.dart';
import '../models/recipe.dart';
import '../providers/meal_plan_provider.dart';
import '../providers/recipe/recipe_provider.dart';
import '../widgets/save_button.dart';

class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});
  @override
  ConsumerState<PlanScreen> createState() => PlanScreenState();
}

class PlanScreenState extends ConsumerState<PlanScreen>{
  PlanScreenState();
  int portion = 1;

  @override
  Widget build(BuildContext context) {
    //:TODO это явно должно выглядеть как-то иначе в итоге
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedRecipe = ref.watch(selectedRecipeProvider);
    final maxPortion = selectedRecipe?.portion ?? 0;

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
            if (selectedRecipe != null) Row(
              children: [
                Text('Количество порций:'),
                SizedBox(width: 10),
                IconButton(onPressed: () => portion > 1 ? setState( () => portion--) : null, icon: Icon(Icons.remove)),
                Text('$portion(из $maxPortion)'),
                IconButton(onPressed: () => portion < maxPortion ? setState( () => portion++) : null, icon: Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 16),
            SaveButton(
              isActive: selectedRecipe != null,
              onSave: () {
                if (selectedRecipe != null) {
                  ref
                      .read(mealPlanProvider.notifier)
                      .saveRecipe(selectedDate, selectedRecipe, portion);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                      const SnackBar(content: Text('План добавлен')));
                }
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
