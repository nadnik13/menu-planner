import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'package:collection/collection.dart';

/// **DishStockNotifier** - управляет состоянием запасов блюд

class DishStockNotifier extends StateNotifier<Set<DishStock>> {
  DishStockNotifier() : super(<DishStock>{});

  void addValues(Set<DishStock> meals) {
    state = {...state, ...meals};
  }

  /// Используется в UI для отображения названий в планах
  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  DishStock? getByKey(String key) => state.where((e) => e.id == key).firstOrNull;

  /// Фильтрация доступных запасов (с остатком > 0)
  Set<DishStock> getAvailableValues() => state.where((e) => e.availablePortion > 0).toSet();
  
  /// Подсчет общего количества доступных порций
  int getCntAvailablePortion() => state.where((e) => e.availablePortion > 0).map((e) => e.availablePortion).sum;
  
  Set<DishStock> findByTemplateId(String recipeKey) => state.where((e) => e.templateId == recipeKey).toSet();

  void addOrReplace(DishStock meal) {
    state = state.where((e) => e.id != meal.id).toSet();
    state = {...state, meal};
  }

  void removeByKey(String key) {
    state = state.where((e) => e.id != key).toSet();
  }
}

/// **Основной провайдер состояния запасов блюд**
/// 
/// StateNotifierProvider обеспечивает:
/// - Автоматическое уведомление подписчиков об изменениях
/// - Immutable обновления состояния
/// - Интеграцию с DevTools для отладки
final dishStockProvider = StateNotifierProvider<DishStockNotifier, Set<DishStock>>((ref) {
  return DishStockNotifier();
});

/// **Провайдер статистики доступных порций**
final availablePortionsCountProvider = Provider<int>((ref) {
  final stocks = ref.watch(dishStockProvider);
  return stocks
      .where((e) => e.availablePortion > 0)
      .map((e) => e.availablePortion)
      .sum;
});
