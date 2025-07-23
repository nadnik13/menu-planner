import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/providers/shared/providers.dart';
import 'package:hive/hive.dart';

import '../../models/daily_plan/daily_plan.dart';
import '../dish_stock/providers.dart';
import 'interactor.dart';
import 'notifier.dart';
import 'repository.dart';
import 'save_interactor.dart';
import 'view_interactor.dart';

abstract class DailyPlanProviders {
  DailyPlanProviders._();

  static final _repository = Provider((ref) {
    final box = Hive.box<DailyPlan>('DailyPlanBox');
    return DailyPlanRepository(box);
  });

  static final planProvider =
      StateNotifierProvider<DailyPlanNotifier, List<DailyPlan>>((ref) {
        final repo = ref.watch(DailyPlanProviders._repository);
        return DailyPlanNotifier(repo);
      });

  static final interactor = Provider<DailyPlanInteractor>((ref) {
    final notifier = ref.watch(planProvider.notifier);
    return DailyPlanInteractor(notifier);
  });

  static final daysProvider = Provider<Map<DateTime, DailyPlan>>((ref) {
    final plans = ref.watch(planProvider);
    return {for (var e in plans) e.date: e};
  });

  static final futurePlansCountProvider = Provider<int>((ref) {
    final plans = ref.watch(planProvider);
    return plans.where((e) => e.date.isAfter(DateTime.now())).length;
  });

  static final saveInteractor = Provider((ref) {
    return DailyPlanSaveInteractor(
      ref.read(DailyPlanProviders.interactor),
      ref.read(DishStockProviders.interactor),
    );
  });

  static final isHideUnavailableStocksStateProvider =
      StateNotifierProvider<DailyPlanIsHideUnavailableStocksNotifier, bool>(
        (ref) => DailyPlanIsHideUnavailableStocksNotifier(),
      );

  static final isHideEmptyDaysStateProvider =
      StateNotifierProvider<DailyPlanIsHideEmptyDaysNotifier, bool>(
        (ref) => DailyPlanIsHideEmptyDaysNotifier(),
      );

  static final viewInteractor = Provider((ref) {
    final isHideEmptyDaysNotifier = ref.read(
      isHideEmptyDaysStateProvider.notifier,
    );
    final isHideUnavailableStocksNotifier = ref.read(
      isHideUnavailableStocksStateProvider.notifier,
    );
    final tabIndexProviderNotifier = ref.read(
      SharedProviders.tabIndexProvider.notifier,
    );
    return DailyPlanViewInteractor(
      isHideEmptyDaysNotifier,
      isHideUnavailableStocksNotifier,
      tabIndexProviderNotifier,
    );
  });
}
