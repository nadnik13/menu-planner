import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:food_planner/core/logger.dart';
import 'package:food_planner/models/dish_stock/dish_stock_status_types.dart';
import 'package:food_planner/models/dish_template/dish_template.dart';
import 'package:food_planner/providers/dish_stock/dish_stock_repository.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'dish_stock_provider.dart';
import 'package:collection/collection.dart';

class DishStockInteractor {
  final DishStockRepository repo;
  final DishStockNotifier notifier;

  DishStockInteractor(this.repo, this.notifier);

  Future<void> loadValues() async {
    final values = await repo.fetchAll();
    notifier.addValues(values);
  }

  void _printBox() {
    final box = Hive.box<DishStock>('dishStockBox');
    logger.d('📦 Всего блюд: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  int getCntAvailablePortion() {
    logger.d("getStatistic");
    _printBox();
    final value = notifier.getCntAvailablePortion();

    logger.d("getAvailableStocks: ${notifier.getAvailableValues().length}");
    return value;
  }

  Map<String, String> getTitleMap() => notifier.getTitleMap();

  Set<DishStock> getAvailableValues() => notifier.getAvailableValues();

  Future<void> addOrReplace(DishStock stock) async {
    await repo.addOrReplace(stock);
    notifier.addOrReplace(stock);
  }

  //:TODO что лучше Dish Stock или dish_stock.id
  Future<void> updatePortion({
    required DishStock stock,
    required int usedCntPortion,
  }) async {
    final updatedStock = stock.copyWith(usedCntPortion: usedCntPortion);
    await repo.addOrReplace(updatedStock);
    notifier.addOrReplace(updatedStock);
  }

  Future<void> updateStatusByKey({
    required String key,
    required DishStockStatusType? status,
  }) async {
    final stock = notifier.getByKey(key);
    if (stock == null || status == null) return;
    final updatedStock = stock.copyWith(status: status);
    logger.d(
      'updateStatus ${updatedStock.id} ${updatedStock.title} ${updatedStock.status}',
    );
    await repo.addOrReplace(updatedStock);
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
    await repo.removeById(key);
    notifier.removeByKey(key);
  }
}

final dishStockRepositoryProvider = Provider((ref) {
  final box = Hive.box<DishStock>('DishStockBox');
  return DishStockRepository(box);
});

final dishStockInteractorProvider = Provider((ref) {
  return DishStockInteractor(
    ref.read(dishStockRepositoryProvider),
    ref.read(dishStockProvider.notifier),
  );
});
