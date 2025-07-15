import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyPlanIsHideEmptyDaysNotifier extends StateNotifier<bool> {
  DailyPlanIsHideEmptyDaysNotifier() : super(false);

  void changeValue() {
    state = !state;
  }
}

class DailyPlanIsHideUnavailableStocksNotifier extends StateNotifier<bool> {
  DailyPlanIsHideUnavailableStocksNotifier() : super(false);

  void changeValue() {
    state = !state;
  }
}

class TabIndexProviderNotifier extends StateNotifier<int> {
  TabIndexProviderNotifier() : super(0);

  void changeValue(int index) {
    state = index;
  }
}

class DailyPlanViewInteractor {
  final DailyPlanIsHideEmptyDaysNotifier isHideEmptyDaysNotifier;
  final DailyPlanIsHideUnavailableStocksNotifier isHideUnavailableStocksNotifier;
  final TabIndexProviderNotifier tabIndexNotifier;

  DailyPlanViewInteractor(
    this.isHideEmptyDaysNotifier,
    this.isHideUnavailableStocksNotifier,
    this.tabIndexNotifier,
  );

  void changeIsHideValue(int tabIndex) {
    switch (tabIndex) {
      case 0:
        changeIsHideEmptyDays();
      case 1:
        changeIsHideUnavailableStocks();
      default:
        () => {};
    }
  }

  void changeTabIndex(int index) => tabIndexNotifier.changeValue(index);

  void changeIsHideEmptyDays() => isHideEmptyDaysNotifier.changeValue();

  void changeIsHideUnavailableStocks() =>
      isHideUnavailableStocksNotifier.changeValue();
}

final dailyPlanIsHideUnavailableStocksStateProvider =
    StateNotifierProvider<DailyPlanIsHideUnavailableStocksNotifier, bool>(
      (ref) => DailyPlanIsHideUnavailableStocksNotifier(),
    );

final dailyPlanIsHideEmptyDaysStateProvider =
    StateNotifierProvider<DailyPlanIsHideEmptyDaysNotifier, bool>(
      (ref) => DailyPlanIsHideEmptyDaysNotifier(),
    );

final tabIndexProvider = StateNotifierProvider<TabIndexProviderNotifier, int>(
  (ref) => TabIndexProviderNotifier(),
);

final dailyPlanViewInteractorProvider = Provider((ref) {
  final isHideEmptyDaysNotifier = ref.read(
    dailyPlanIsHideEmptyDaysStateProvider.notifier,
  );
  final isHideUnavailableStocksNotifier = ref.read(
    dailyPlanIsHideUnavailableStocksStateProvider.notifier,
  );
  final tabIndexProviderNotifier = ref.read(tabIndexProvider.notifier);
  return DailyPlanViewInteractor(
    isHideEmptyDaysNotifier,
    isHideUnavailableStocksNotifier,
    tabIndexProviderNotifier,
  );
});
