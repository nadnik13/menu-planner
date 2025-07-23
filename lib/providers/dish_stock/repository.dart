import 'package:hive/hive.dart';
import '../../models/dish_stock/dish_stock.dart';

class DishStockRepository {
  final Box<DishStock> _box;

  DishStockRepository(this._box);

  Future<void> addOrReplace(DishStock value) async {
    await _box.put(value.id, value);
  }

  Future<DishStock?> getById(String id) async => _box.get(id);

  Future<Set<DishStock>> fetchAll() async => _box.values.toSet();

  Future<void> removeById(String id) async {
    await _box.delete(id);
  }
}
