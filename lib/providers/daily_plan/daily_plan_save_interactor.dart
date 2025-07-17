import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/providers/daily_plan/daily_plan_interactor.dart';
import '../dish_stock/dish_stock_interactor.dart';

class DailyPlanSaveInteractor {
  final DailyPlanInteractor planInteractor;
  final DishStockInteractor mealInteractor;

  DailyPlanSaveInteractor(this.planInteractor, this.mealInteractor);

  Future<void> save({
    required Map<String, int> dishStockCntMap,
    required Map<String, int> changedDishStockPortions,
    required DateTime date,
  }) async {
    await mealInteractor.updateValues(stockMap: changedDishStockPortions);
    if (dishStockCntMap.isEmpty){
      await planInteractor.removeByDate(date);
    }
    else {
      await planInteractor.save(date: date, dishStockCntMap: dishStockCntMap);
    }
  }
}

final dailyPlanSaveInteractorProvider = Provider((ref) {
  return DailyPlanSaveInteractor(
    ref.read(dailyPlanInteractorProvider),
    ref.read(dishStockInteractorProvider),
  );
});
