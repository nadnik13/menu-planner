import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'package:collection/collection.dart';

class DishStockNotifier extends StateNotifier<Set<DishStock>> {
  DishStockNotifier() : super(<DishStock>{}) {}

  void addValues(Set<DishStock> meals) {
    state = {...state, ...meals};
  }

  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  DishStock? getByKey(String key) => state.where((e) => e.id == key).firstOrNull;

  Set<DishStock> getAvailableValues() => state.where((e) => e.availablePortion > 0).toSet();
  int getCntAvailablePortion() => state.where((e) => e.availablePortion > 0).map((e) => e.availablePortion).sum;
  Set<DishStock> findByTemplateId(String recipeKey)
   => state.where((e) => e.recipeId == recipeKey).toSet();


  void addOrReplace(DishStock meal) {
    state = state.where((e) => e.id != meal.id).toSet();
    state = {...state, meal};
  }

  void removeByKey(String key) {
    state = state.where((e) => e.id != key).toSet();
  }
}

final dishStockProvider = StateNotifierProvider<DishStockNotifier, Set<DishStock>>((ref) {
  return DishStockNotifier();
});

/// ✅ РЕАКТИВНЫЙ провайдер для статистики порций
/// Автоматически пересчитывается при изменении dishStockProvider
final availablePortionsCountProvider = Provider<int>((ref) {
  final stocks = ref.watch(dishStockProvider);
  return stocks
      .where((e) => e.availablePortion > 0)
      .map((e) => e.availablePortion)
      .sum;
});
