import 'package:food_planner/providers/daily_plan/interactor.dart';
import '../dish_stock/interactor.dart';

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