import 'package:food_planner/providers/daily_plan/daily_plan_interactor.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'dish_stock_interactor.dart';

class DishStockRemoveInteractor {
  final DishStockInteractor dishStockInteractor;
  final DailyPlanInteractor planInteractor;

  DishStockRemoveInteractor(this.dishStockInteractor, this.planInteractor);

  Future<void> remove(DishStock stock) async {
    final key = stock.id;
    await dishStockInteractor.removeByKey(key);
    await planInteractor.removeMealFromPlans(key);
  }
}
