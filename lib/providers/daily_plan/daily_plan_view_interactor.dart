import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlanIsHideEmptyDaysNotifier extends StateNotifier<bool> {
  MealPlanIsHideEmptyDaysNotifier() : super(false);

  void changeValue() {
    state = !state;
  }
}

class MealPlanIsHideUnavailableMealsNotifier extends StateNotifier<bool> {
  MealPlanIsHideUnavailableMealsNotifier() : super(false);

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
  final DailyPlanIsHideEmptyDaysStateNotifier isHideEmptyDaysNotifier;
  final DishPlanIsHideUnavailableDishStateNotifier isHideUnavailableDishesNotifier;
  final TabIndexProviderNotifier tabIndexProviderNotifier;

  DailyPlanViewInteractor(
    this.isHideEmptyDaysNotifier,
    this.isHideUnavailableDishesNotifier,
    this.tabIndexProviderNotifier,
  );

  void toggleHideEmptyDays() {
    isHideEmptyDaysNotifier.toggle();
  }

  void toggleHideUnavailableDishes() {
    isHideUnavailableDishesNotifier.toggle();
  }

  void changeTabIndex(int index) {
    tabIndexProviderNotifier.changeValue(index);
  }
}

final dailyPlanIsHideEmptyDaysStateProvider =
    StateNotifierProvider<DailyPlanIsHideEmptyDaysStateNotifier, bool>(
  (ref) => DailyPlanIsHideEmptyDaysStateNotifier(),
);

class DailyPlanIsHideEmptyDaysStateNotifier extends StateNotifier<bool> {
  DailyPlanIsHideEmptyDaysStateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final dishPlanIsHideUnavailableDishStateProvider =
    StateNotifierProvider<DishPlanIsHideUnavailableDishStateNotifier, bool>(
  (ref) => DishPlanIsHideUnavailableDishStateNotifier(),
);

class DishPlanIsHideUnavailableDishStateNotifier extends StateNotifier<bool> {
  DishPlanIsHideUnavailableDishStateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final dishPlanIsHideUnavailableDishSwitchStateProvider =
    StateNotifierProvider<DishPlanIsHideUnavailableDishSwitchStateNotifier, bool>(
  (ref) => DishPlanIsHideUnavailableDishSwitchStateNotifier(),
);

class DishPlanIsHideUnavailableDishSwitchStateNotifier
    extends StateNotifier<bool> {
  DishPlanIsHideUnavailableDishSwitchStateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final tabIndexProvider = StateNotifierProvider<TabIndexProviderNotifier, int>(
  (ref) => TabIndexProviderNotifier(),
);

final dailyPlanViewInteractorProvider = Provider((ref) {
  final isHideEmptyDaysNotifier = ref.read(
    dailyPlanIsHideEmptyDaysStateProvider.notifier,
  );
  final isHideUnavailableDishesNotifier = ref.read(
    dishPlanIsHideUnavailableDishStateProvider.notifier,
  );
  final tabIndexProviderNotifier = ref.read(tabIndexProvider.notifier);

  return DailyPlanViewInteractor(
    isHideEmptyDaysNotifier,
    isHideUnavailableDishesNotifier,
    tabIndexProviderNotifier,
  );
});
