import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/models/daily_plan/daily_plan.dart';
import 'package:food_planner/widgets/styled_button.dart';
import '../models/dish_stock/dish_stock.dart';
import '../providers/daily_plan/daily_plan_providers.dart';
import '../providers/dish_stock/dish_stock_providers.dart';
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
          meal.availablePortion + (plannedDishPortionsByDate ?? 0),
        ),
      );
    }
    return list;
  }
}

class _PlanEditingWidgetState extends ConsumerState<PlanEditingWidget> {
  final List<_PlannedDishItem> _selectedDishes = [];
  final List<_PlannedDishItem> _availableDishesToAdd = [];
  final _changedDishPortions = <String, int>{};

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  void _loadDishes() {
    final dishes =
        ref.read(DishStockProviders.interactor).getValues();
    final selectedDate = widget.selectedDate;
    final planByDate = ref
        .read(DailyPlanProviders.interactor)
        .getPlanByDate(selectedDate);

    _selectedDishes.clear();
    _availableDishesToAdd.clear();
    _changedDishPortions.clear();

    final items = _PlannedDishItem.generateFromMeal(
      dishes,
      planByDate,
    );
    for (final mealItem in items) {
      if (mealItem.usedPortion > 0) {
        _selectedDishes.add(mealItem);
      } else {
        if (mealItem.availablePortion > 0) {
          _availableDishesToAdd.add(mealItem);
        }
      }
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
        .read(DailyPlanProviders.saveInteractor)
        .save(
          date: widget.selectedDate,
          changedDishStockPortions: _changedDishPortions,
          dishStockCntMap: {for (var e in _selectedDishes) e.id: e.usedPortion},
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
        SizedBox(height: 8),
        _buildMealList(_selectedDishes, isBusyList: true),
        SizedBox(height: 16),
        _buildSectionTitle('Для добавления'),
        SizedBox(height: 8),
        _buildMealList(_availableDishesToAdd, isBusyList: false),
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

  Widget _buildSectionTitle(String title) =>
      Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));

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
                    Expanded(
                      child: Text(
                        entity.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                                    _availableDishesToAdd.add(entity);
                                  }
                                  _changedDishPortions[entity.id] =
                                      (_changedDishPortions[entity.id] ?? 0) - 1;
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
                                    _selectedDishes.add(entity);
                                  }
                                  _changedDishPortions[entity.id] =
                                      (_changedDishPortions[entity.id] ?? 0) + 1;
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
