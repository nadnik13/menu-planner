import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock.dart';
import '../../models/dish_template.dart';
import 'dish_stock_notifier.dart';
import 'dish_stock_provider.dart';
import 'dish_stock_repository.dart';

class DishStockInteractor {
  final DishStockNotifier _notifier;
  final DishStockRepository _repository;

  DishStockInteractor(this._notifier, this._repository);

  Future<void> loadStocks() async {
    try {
      final stocks = await _repository.loadStocks();
      _notifier.loadStocks(stocks);
    } catch (e) {
      print('❌ Ошибка загрузки запасов: $e');
    }
  }

  Future<void> addStockByTemplate(DishTemplate template) async {
    try {
      final stock = DishStock.add(template);
      await _repository.saveStock(stock);
      await _notifier.addStock(stock);
    } catch (e) {
      print('❌ Ошибка добавления запаса: $e');
    }
  }

  DishStock? getStockById(String id) {
    try {
      return _notifier.fetchAllStocks.firstWhere(
        (stock) => stock.id == id,
        orElse: () => throw Exception('Stock not found'),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDishStockPortion({
    required DishStock stock,
    required int usedCntPortions,
  }) async {
    try {
      final updatedStock = stock.copyWith(usedCntPortions: usedCntPortions);
      await _repository.saveStock(updatedStock);
      _notifier.updateStock(updatedStock);
    } catch (e) {
      print('❌ Ошибка обновления запаса: $e');
    }
  }

  Future<void> removeStock(DishStock stock) async {
    try {
      await _repository.deleteStock(stock);
      await _notifier.removeStock(stock);
    } catch (e) {
      print('❌ Ошибка удаления запаса: $e');
    }
  }

  Future<void> updateStock(DishStock stock) async {
    try {
      await _repository.saveStock(stock);
      await _notifier.updateStock(stock);
    } catch (e) {
      print('❌ Ошибка обновления запаса: $e');
    }
  }
}

final dishStockInteractorProvider = Provider<DishStockInteractor>((ref) {
  final repository = ref.watch(dishStockRepositoryProvider);
  final notifier = ref.watch(dishStockProvider.notifier);
  return DishStockInteractor(notifier, repository);
}); 