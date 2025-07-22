import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'package:collection/collection.dart';

import 'dish_stock_repository.dart';

class DishStockNotifier extends StateNotifier<Set<DishStock>> {
  DishStockNotifier(this.repo) : super(<DishStock>{});
  final DishStockRepository repo;

  Future<void> loadValues() async {
    final values = await repo.fetchAll();
    state = {...state, ...values};
  }

  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  DishStock? getByKey(String key) =>
      state.where((e) => e.id == key).firstOrNull;

  Set<DishStock> get getValues => state;

  int getCntAvailablePortion() =>
      state
          .where((e) => e.availablePortion > 0)
          .map((e) => e.availablePortion)
          .sum;

  Set<DishStock> findByTemplateId(String recipeKey) =>
      state.where((e) => e.templateId == recipeKey).toSet();

  Future<void> addOrReplace(DishStock stock) async {
    await repo.addOrReplace(stock);
    state = state.where((e) => e.id != stock.id).toSet();
    state = {...state, stock};
  }

  Future<void> removeByKey(String key) async {
    await repo.removeById(key);
    state = state.where((e) => e.id != key).toSet();
  }
}