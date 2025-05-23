import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/models/meal_plan.dart';
import 'package:my_recipe_app/providers/meal/meal_interactor.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_save_interactor.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_interactor.dart';
import 'package:my_recipe_app/widgets/save_button.dart';

import '../models/meal.dart';

class MealList extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const MealList({super.key, required this.selectedDate});

  @override
  ConsumerState<MealList> createState() => _MealListState();
}

class _PlannedMealItem {
  final String id;
  final String title;
  int usedPortion;
  final int availablePortion;

  _PlannedMealItem(
    this.id,
    this.title,
    this.usedPortion,
    this.availablePortion,
  );

  static List<_PlannedMealItem> generateFromMeal(
    Set<Meal> meals,
    MealPlan mealPlan,
  ) {
    final List<_PlannedMealItem> list = [];
    for (final meal in meals) {
      final plannedMealPortionsByDate = mealPlan.mealPortions[meal.id];
      list.add(
        _PlannedMealItem(
          meal.id,
          meal.title,
          plannedMealPortionsByDate ?? 0,
          meal.availablePortion,
        ),
      );
    }
    return list;
  }
}

class _MealListState extends ConsumerState<MealList> {
  final List<_PlannedMealItem> selectedMeals = [];
  final List<_PlannedMealItem> availableMealsToAdd = [];
  final changedMealPortions = <String, int>{};

  @override
  void initState() {
    super.initState();
      _loadMeals();
  }

  void _loadMeals() {
    final availableMeals = ref.read(mealInteractorProvider).getAvailableMeals();
    logger.d("_loadMeals availableMeals: ${availableMeals.length}");
    logger.d("_loadMeals availableMealsTitles: ${availableMeals.map((e) => e.title)}");
    final selectedDate = widget.selectedDate;
    final planByDate = ref
        .read(mealPlanInteractorProvider)
        .getPlanByDate(selectedDate);
    logger.d("selectedDate: ${widget.selectedDate} ${selectedDate}");
    logger.d("planByDate: ${planByDate.date} ${planByDate.mealPortions}");
    selectedMeals.clear();
    availableMealsToAdd.clear();
    changedMealPortions.clear();
    //:TODO можно ли убрать выгрузку из интерактора в функцию генерации?
    final items = _PlannedMealItem.generateFromMeal(availableMeals, planByDate);
    for (final mealItem in items) {
      if (mealItem.usedPortion > 0) {
        selectedMeals.add(mealItem);
      } else {
        availableMealsToAdd.add(mealItem);
      }
      changedMealPortions[mealItem.id] = mealItem.usedPortion;
    }
    logger.d("_loadMeals selectedMeals: ${selectedMeals.map((e) => e.title)}");
    logger.d("_loadMeals availableMealsToAdd: ${availableMealsToAdd.map((e) => e.title)}");
    logger.d("_loadMeals changedMealPortions: ${changedMealPortions}");
  }

  @override
  void didUpdateWidget(MealList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
        _loadMeals();
    }
  }

  void _save() {
    ref
        .read(mealPlanSaveInteractorProvider)
        .saveMealPLan(
          date: widget.selectedDate,
          changedMealPortions: changedMealPortions,
          mealCntMap: {for (var e in selectedMeals) e.id: e.usedPortion},
        );
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('План добавлен')));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Выбранные блюда'),
          _buildMealList(selectedMeals, isBusyList: true),
          SizedBox(height: 16),
          _buildSectionTitle('Для добавления'),
          _buildMealList(availableMealsToAdd, isBusyList: false),
          SaveButton(isActive: true, onSave: _save),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
    child: Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildMealList(
    List<_PlannedMealItem> meals, {
    required bool isBusyList,
  }) {
    return Expanded(
      child: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, i) {
          final entity = meals[i];
          return Row(
            children: [
              SizedBox(width: 200, child: Text(entity.title)),
              SizedBox(width: 10),
              IconButton(
                onPressed:
                    () =>
                        entity.usedPortion > 0
                            ? setState(() {
                              entity.usedPortion--;
                              if (entity.usedPortion == 0 && isBusyList) {
                                meals.removeAt(i);
                                availableMealsToAdd.add(entity);
                              }
                              changedMealPortions[entity.id] =
                                  (changedMealPortions[entity.id] ?? 0) - 1;
                            })
                            : null,
                icon: Icon(Icons.remove),
              ),
              Text('${entity.usedPortion}(из ${entity.availablePortion})'),
              IconButton(
                onPressed:
                    () =>
                        entity.usedPortion < entity.availablePortion
                            ? setState(() {
                              entity.usedPortion++;
                              if (entity.usedPortion == 1 && !isBusyList) {
                                meals.removeAt(i);
                                selectedMeals.add(entity);
                              }
                              changedMealPortions[entity.id] =
                                  (changedMealPortions[entity.id] ?? 0) + 1;
                            })
                            : null,
                icon: Icon(Icons.add),
              ),
            ],
          );
        },
      ),
    );
  }
}
