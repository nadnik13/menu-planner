import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock/dish_stock.dart';
import 'package:collection/collection.dart';

import 'dish_stock_interactor.dart';
import 'dish_stock_repository.dart';

/// **DishStockNotifier** - управляет состоянием запасов блюд

class DishStockNotifier extends StateNotifier<Set<DishStock>> {
  DishStockNotifier(this.repo) : super(<DishStock>{});
  final DishStockRepository repo;

  Future<void> loadValues() async {
    final values = await repo.fetchAll();
    state = {...state, ...values};
  }

  /// Используется в UI для отображения названий в планах
  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  DishStock? getByKey(String key) =>
      state.where((e) => e.id == key).firstOrNull;

  /// Фильтрация доступных запасов (с остатком > 0)
  Set<DishStock> getAvailableValues() =>
      state.where((e) => e.availablePortion > 0).toSet();

  /// Подсчет общего количества доступных порций
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

/// **Основной провайдер состояния запасов блюд**
///
/// StateNotifierProvider обеспечивает:
/// - Автоматическое уведомление подписчиков об изменениях
/// - Immutable обновления состояния
/// - Интеграцию с DevTools для отладки
final dishStockProvider =
    StateNotifierProvider<DishStockNotifier, Set<DishStock>>((ref) {
      final repo = ref.read(dishStockRepositoryProvider);
      return DishStockNotifier(repo);
    });

/// **Провайдер статистики доступных порций**
final availablePortionsCountProvider = Provider<int>((ref) {
  final stocks = ref.watch(dishStockProvider);
  return stocks
      .where((e) => e.availablePortion > 0)
      .map((e) => e.availablePortion)
      .sum;
});
