import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/models/daily_plan/daily_plan.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_save_interactor.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_interactor.dart';
import 'package:my_recipe_app/widgets/styled_button.dart';
import '../models/dish_stock/dish_stock.dart';
import '../utils/emoji_utils.dart';

class PlanEditingWidget extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const PlanEditingWidget({super.key, required this.selectedDate});

  @override
  ConsumerState<PlanEditingWidget> createState() => _PlanEditingWidgetState();
}

class _PlannedDishItem {
  final String id;
  final String title;
  int usedPortion;
  final int availablePortion;

  _PlannedDishItem(
    this.id,
    this.title,
    this.usedPortion,
    this.availablePortion,
  );

  static List<_PlannedDishItem> generateFromMeal(
    Set<DishStock> meals,
    DailyPlan mealPlan,
  ) {
    final List<_PlannedDishItem> list = [];
    for (final meal in meals) {
      final plannedDishPortionsByDate = mealPlan.portions[meal.id];
      list.add(
        _PlannedDishItem(
          meal.id,
          meal.title,
          plannedDishPortionsByDate ?? 0,
          meal.availablePortion,
        ),
      );
    }
    return list;
  }
}

class _PlanEditingWidgetState extends ConsumerState<PlanEditingWidget> {
  final List<_PlannedDishItem> selectedDishes = [];
  final List<_PlannedDishItem> availableDishesToAdd = [];
  final changedDishPortions = <String, int>{};

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  void _loadDishes() {
    final availableDishes = ref.read(dishStockInteractorProvider).getAvailableValues();
    final selectedDate = widget.selectedDate;
    final planByDate = ref
        .read(dailyPlanInteractorProvider)
        .getPlanByDate(selectedDate);
    selectedDishes.clear();
    availableDishesToAdd.clear();
    changedDishPortions.clear();
    //:TODO можно ли убрать выгрузку из интерактора в функцию генерации?
    final items = _PlannedDishItem.generateFromMeal(availableDishes, planByDate);
    for (final mealItem in items) {
      if (mealItem.usedPortion > 0) {
        selectedDishes.add(mealItem);
      } else {
        availableDishesToAdd.add(mealItem);
      }
      changedDishPortions[mealItem.id] = mealItem.usedPortion;
    }
  }

  @override
  void didUpdateWidget(PlanEditingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadDishes();
    }
  }

  void _save() {
    ref
        .read(dailyPlanSaveInteractorProvider)
        .save(
          date: widget.selectedDate,
          changedDishStockPortions: changedDishPortions,
          dishStockCntMap: {for (var e in selectedDishes) e.id: e.usedPortion},
        );
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('План добавлен')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Выбранные блюда'),
        _buildMealList(selectedDishes, isBusyList: true),
        SizedBox(height: 16),
        _buildSectionTitle('Для добавления'),
        _buildMealList(availableDishesToAdd, isBusyList: false),
        Row(
          children: [
            Expanded(
              child: StyledButton(
                isActive: true,
                onPress: _save,
                text: 'Сохранить',
                type: ButtonType.dark,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  Widget _buildMealList(
    List<_PlannedDishItem> meals, {
    required bool isBusyList,
  }) {
    return Expanded(
      child: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, i) {
          final entity = meals[i];
          return Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      getEmojiForMeal(entity.title),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      entity.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed:
                        () =>
                            entity.usedPortion > 0
                                ? setState(() {
                                  entity.usedPortion--;
                                  if (entity.usedPortion == 0 && isBusyList) {
                                    meals.removeAt(i);
                                    availableDishesToAdd.add(entity);
                                  }
                                  changedDishPortions[entity.id] =
                                      (changedDishPortions[entity.id] ?? 0) - 1;
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
                                    selectedDishes.add(entity);
                                  }
                                  changedDishPortions[entity.id] =
                                      (changedDishPortions[entity.id] ?? 0) + 1;
                                })
                                : null,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
