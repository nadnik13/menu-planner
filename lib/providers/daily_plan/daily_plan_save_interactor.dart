import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import '../dish_stock/dish_stock_interactor.dart';
import 'daily_plan_interactor.dart';
import '../../models/dish_stock.dart';
import '../../models/daily_plan.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_interactor.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';

class DailyPlanSaveInteractor {
  final DailyPlanInteractor planInteractor;
  final DishStockInteractor dishStockInteractor;

  DailyPlanSaveInteractor(this.planInteractor, this.dishStockInteractor);

  Future<void> savePlan({
    required DateTime date,
    required Map<String, int> changedDishStockPortions,
    required Map<String, int> dishCntMap,
  }) async {
    try {
      // Обновляем запасы
      for (final entry in changedDishStockPortions.entries) {
        final stock = dishStockInteractor.getStockById(entry.key);
        if (stock != null) {
          await dishStockInteractor.updateDishStockPortion(
            stock: stock,
            usedCntPortions: entry.value,
          );
        }
      }

      // Создаем и сохраняем план
      final dishes = dishCntMap.entries.map((entry) {
        final stock = dishStockInteractor.getStockById(entry.key);
        if (stock == null) {
          throw Exception('Stock not found for dish: ${entry.key}');
        }
        return stock;
      }).toSet();

      final plan = DailyPlan(
        date: date,
        dishes: dishes.toList(),
      );
      await planInteractor.savePlan(plan);
    } catch (e) {
      rethrow;
    }
  }
}

final dailyPlanSaveInteractorProvider = Provider((ref) {
  return DailyPlanSaveInteractor(
    ref.read(dailyPlanInteractorProvider),
    ref.read(dishStockInteractorProvider),
  );
});
