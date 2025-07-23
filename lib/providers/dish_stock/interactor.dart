import 'package:hive/hive.dart';
import 'package:food_planner/core/logger.dart';
import 'package:food_planner/models/dish_stock/dish_stock_status_types.dart';
import 'package:food_planner/models/dish_template/dish_template.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'notifier.dart';
import 'package:collection/collection.dart';

class DishStockInteractor {
  final DishStockNotifier notifier;

  DishStockInteractor(this.notifier);

  Future<void> loadValues() async {
    notifier.loadValues();
    _printBox();
  }

  void _printBox() {
    final box = Hive.box<DishStock>('dishStockBox');
    logger.d('📦 Всего блюд: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  int getCntAvailablePortion() {
    final value = notifier.getCntAvailablePortion();
    return value;
  }

  Map<String, String> getTitleMap() => notifier.getTitleMap();

  Set<DishStock> getValues() => notifier.getValues;

  Future<void> addOrReplace(DishStock stock) async {
    notifier.addOrReplace(stock);
  }

  //:TODO что лучше Dish Stock или dish_stock.id
  Future<void> updatePortion({
    required DishStock stock,
    required int usedCntPortion,
  }) async {
    final updatedStock = stock.copyWith(usedCntPortion: usedCntPortion);
    logger.d(
      "updatedStock: ${stock.title} ${stock.usedCntPortion} ${updatedStock.usedCntPortion}",
    );
    notifier.addOrReplace(updatedStock);
  }

  Future<void> updateStatusByKey({
    required String key,
    required DishStockStatusType? status,
  }) async {
    final stock = notifier.getByKey(key);
    if (stock == null || status == null) return;
    final updatedStock = stock.copyWith(status: status);
    notifier.addOrReplace(updatedStock);
  }

  Future<void> updateValues({required Map<String, int> stockMap}) async {
    for (final entry in stockMap.entries) {
      final stock = notifier.getByKey(entry.key);
      if (stock != null) {
        await updatePortion(
          stock: stock,
          usedCntPortion: entry.value + stock.usedCntPortion,
        );
      }
    }
  }

  Future<void> addByDishTemplate(DishTemplate template) async {
    final stockByTemplate = notifier.findByTemplateId(template.id).firstOrNull;
    DishStock updated =
        stockByTemplate != null
            ? stockByTemplate.copyWith(
              addedCntPortion:
                  stockByTemplate.addedCntPortion + template.portion,
            )
            : DishStock.add(template);
    addOrReplace(updated);
  }

  Future<void> removeByKey(String key) async {
    notifier.removeByKey(key);
  }
}
