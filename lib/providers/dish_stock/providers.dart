import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/providers/daily_plan/providers.dart';
import 'package:hive/hive.dart';

import '../../models/dish_stock/dish_stock.dart';
import 'interactor.dart';
import 'notifier.dart';
import 'remove_interactor.dart';
import 'repository.dart';

abstract class DishStockProviders {
  DishStockProviders._();

  static final repository = Provider((ref) {
    final box = Hive.box<DishStock>('DishStockBox');
    return DishStockRepository(box);
  });

  static final provider =
      StateNotifierProvider<DishStockNotifier, Set<DishStock>>((ref) {
        final repo = ref.read(repository);
        return DishStockNotifier(repo);
      });

  static final availablePortionsCountProvider = Provider<int>((ref) {
    final stocks = ref.watch(provider);
    return stocks
        .where((e) => e.availablePortion > 0)
        .map((e) => e.availablePortion)
        .sum;
  });

  static final interactor = Provider((ref) {
    return DishStockInteractor(ref.read(provider.notifier));
  });

  static final removeInteractor = Provider((ref) {
    return DishStockRemoveInteractor(
      ref.read(interactor),
      ref.read(DailyPlanProviders.interactor),
    );
  });
}
