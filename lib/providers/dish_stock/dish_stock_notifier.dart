import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock.dart';

class DishStockNotifier extends StateNotifier<Set<DishStock>> {
  DishStockNotifier() : super({});

  void loadStocks(Set<DishStock> stocks) {
    state = stocks;
  }

  Set<DishStock> get fetchAllStocks {
    return state;
  }

  Future<void> addStocks(Set<DishStock> stocks) async {
    state = {...state, ...stocks};
  }

  Future<void> addStock(DishStock stock) async {
    state = {...state, stock};
  }

  Future<void> removeStock(DishStock stock) async {
    state = state.where((e) => e.id != stock.id).toSet();
  }

  Future<void> updateStock(DishStock stock) async {
    final filteredStocks = state.where((e) => e.id != stock.id).toSet();
    state = {...filteredStocks, stock};
  }
}

final dishStockProvider = StateNotifierProvider<DishStockNotifier, Set<DishStock>>(
  (ref) => DishStockNotifier(),
); 