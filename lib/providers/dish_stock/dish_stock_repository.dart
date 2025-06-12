import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/dish_stock.dart';
import '../../core/hive_box_names.dart';

class DishStockRepository {
  final Box<DishStock> _box;

  DishStockRepository(this._box);

  Future<Set<DishStock>> loadStocks() async {
    return _box.values.toSet();
  }

  Future<void> saveStock(DishStock stock) async {
    await _box.put(stock.id, stock);
  }

  Future<void> deleteStock(DishStock stock) async {
    await _box.delete(stock.id);
  }
}

final dishStockRepositoryProvider = Provider<DishStockRepository>((ref) {
  final box = Hive.box<DishStock>(HiveBoxNames.dishStock);
  return DishStockRepository(box);
}); 