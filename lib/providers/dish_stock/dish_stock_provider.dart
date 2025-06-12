import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock.dart';
import 'package:collection/collection.dart';

class DishStockSetNotifier extends StateNotifier<Set<DishStock>> {
  DishStockSetNotifier() : super(<DishStock>{});

  void addStocks(Set<DishStock> stocks) {
    state = {...state, ...stocks};
  }

  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  DishStock? getStockById(String id) => state.where((e) => e.id == id).firstOrNull;

  Set<DishStock> getAvailableStocks() => state.where((e) => e.availablePortion > 0).toSet();
  int getCntAvailablePortion() => state.where((e) => e.availablePortion > 0).map((e) => e.availablePortion).sum;
  Set<DishStock> findByTemplateId(String templateId)
   => state.where((e) => e.dishTemplateId == templateId).toSet();

  void addOrReplaceStock(DishStock stock) {
    state = state.where((e) => e.id != stock.id).toSet();
    state = {...state, stock};
  }

  void removeStockById(String id) {
    state = state.where((e) => e.id != id).toSet();
  }
}

final dishStockSetProvider = StateNotifierProvider<DishStockSetNotifier, Set<DishStock>>((ref) {
  return DishStockSetNotifier();
});
