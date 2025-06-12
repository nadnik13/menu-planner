import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_stock.dart';
import 'dish_stock_interactor.dart';

class DishStockRemoveInteractor {
  final DishStockInteractor dishStockInteractor;

  DishStockRemoveInteractor(this.dishStockInteractor);

  Future<void> removeStock(DishStock stock) async {
    await dishStockInteractor.removeStock(stock);
  }
}

final dishStockRemoveInteractorProvider = Provider((ref) {
  return DishStockRemoveInteractor(
    ref.read(dishStockInteractorProvider),
  );
});
