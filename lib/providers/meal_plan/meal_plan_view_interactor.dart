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

class MealPlanViewInteractor {
  final MealPlanIsHideEmptyDaysNotifier isHideEmptyDaysNotifier;
  final MealPlanIsHideUnavailableMealsNotifier isHideUnavailableMealsNotifier;
  final TabIndexProviderNotifier tabIndexNotifier;

  MealPlanViewInteractor(
    this.isHideEmptyDaysNotifier,
    this.isHideUnavailableMealsNotifier,
    this.tabIndexNotifier,
  );

  void changeIsHideValue(int tabIndex) {
    switch (tabIndex) {
      case 0:
        changeIsHideEmptyDays();
      case 1:
        changeIsHideUnavailableMeals();
      default:
        () => {};
    }
  }

  void changeTabIndex(int index) => tabIndexNotifier.changeValue(index);

  void changeIsHideEmptyDays() => isHideEmptyDaysNotifier.changeValue();

  void changeIsHideUnavailableMeals() =>
      isHideUnavailableMealsNotifier.changeValue();
}

final mealPlanIsHideUnavailableMealStateProvider =
    StateNotifierProvider<MealPlanIsHideUnavailableMealsNotifier, bool>(
      (ref) => MealPlanIsHideUnavailableMealsNotifier(),
    );

final mealPlanIsHideEmptyDaysStateProvider =
    StateNotifierProvider<MealPlanIsHideEmptyDaysNotifier, bool>(
      (ref) => MealPlanIsHideEmptyDaysNotifier(),
    );

final tabIndexProvider = StateNotifierProvider<TabIndexProviderNotifier, int>(
  (ref) => TabIndexProviderNotifier(),
);

final mealPlanViewInteractorProvider = Provider((ref) {
  final isHideEmptyDaysNotifier = ref.read(
    mealPlanIsHideEmptyDaysStateProvider.notifier,
  );
  final isHideUnavailableMealsNotifier = ref.read(
    mealPlanIsHideUnavailableMealStateProvider.notifier,
  );
  final tabIndexProviderNotifier = ref.read(tabIndexProvider.notifier);
  return MealPlanViewInteractor(
    isHideEmptyDaysNotifier,
    isHideUnavailableMealsNotifier,
    tabIndexProviderNotifier,
  );
});
