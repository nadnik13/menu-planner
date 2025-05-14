import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/providers/meal_provider.dart';
import 'package:my_recipe_app/providers/plan_state_providers.dart';
import '../models/meal.dart';
import '../providers/meal_plan_provider.dart';
import '../widgets/save_button.dart';

class PlanScreen extends ConsumerStatefulWidget {
  final Meal? meal;

  const PlanScreen({super.key, this.meal});

  @override
  ConsumerState<PlanScreen> createState() => PlanScreenState(meal);
}

class PlanScreenState extends ConsumerState<PlanScreen> {
  final Meal? meal;
  int portion = 1;

  PlanScreenState(this.meal);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedMealProvider.notifier).state = meal;
    });
  }

  @override
  Widget build(BuildContext context) {
    //:TODO это явно должно выглядеть как-то иначе в итоге
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedMeal = ref.watch(selectedMealProvider);
    logger.d(
      'Portion: ${selectedMeal?.usedCntPortion} ${selectedMeal?.addedCntPortion} ${selectedMeal?.availablePortion}',
    );
    final availableCntPortion = selectedMeal?.availablePortion ?? 0;

    if (availableCntPortion < 1) {
      portion = 0;
    }

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
            _MealDropdown(
              selectedMeal: selectedMeal,
              onSelectedMeal: (meal) {
                ref.read(selectedMealProvider.notifier).state = meal;
              },
            ),
            const SizedBox(height: 16),
            if (selectedMeal != null)
              Row(
                children: [
                  Text('Количество порций:'),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed:
                        () => portion > 1 ? setState(() => portion--) : null,
                    icon: Icon(Icons.remove),
                  ),
                  Text('$portion(из $availableCntPortion)'),
                  IconButton(
                    onPressed:
                        () =>
                            portion < availableCntPortion
                                ? setState(() => portion++)
                                : null,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            SaveButton(
              isActive: selectedMeal != null && availableCntPortion > 0,
              onSave: () {
                if (selectedMeal != null && availableCntPortion > 0) {
                  ref
                      .read(mealPlanProvider.notifier)
                      .saveMealPlan(
                        date: selectedDate,
                        meal: selectedMeal,
                        portion: portion,
                      );

                  ref
                      .read(mealProvider.notifier)
                      .updateMeal(meal: selectedMeal, usedCntPortion: portion);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('План добавлен')),
                  );
                  ref.invalidate(selectedMealProvider);
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

class _MealDropdown extends ConsumerWidget {
  final Meal? selectedMeal;
  final ValueChanged<Meal?> onSelectedMeal;

  const _MealDropdown({
    required this.selectedMeal,
    required this.onSelectedMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealProvider);
    return DropdownButton<Meal>(
      value: selectedMeal,
      hint: const Text("Выбрать рецепт"),
      isExpanded: true,
      items:
          meals.map((meal) {
            return DropdownMenuItem<Meal>(value: meal, child: Text(meal.title));
          }).toList(),
      onChanged: onSelectedMeal,
    );
  }
}
