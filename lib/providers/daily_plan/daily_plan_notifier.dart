import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/models/daily_plan.dart';
import 'package:my_recipe_app/models/daily_plan_state.dart';

class DailyPlanNotifier extends StateNotifier<DailyPlanState> {
  DailyPlanNotifier() : super(const DailyPlanState.initial());

  void loadPlans(List<DailyPlan> plans) {
    state = DailyPlanState.loaded(plans);
  }

  List<DailyPlan> get fetchAllPlans {
    return state.maybeWhen(
      loaded: (plans) => plans,
      orElse: () => [],
    );
  }

  Future<void> addPlan(DailyPlan plan) async {
    state.maybeWhen(
      loaded: (plans) {
        final filteredPlans = plans.where((p) => p.date != plan.date).toList();
        if (filteredPlans.isNotEmpty) {
          state = DailyPlanState.loaded([...filteredPlans, plan]);
        } else {
          state = DailyPlanState.loaded([plan]);
        }
      },
      orElse: () {
        state = DailyPlanState.loaded([plan]);
      },
    );
  }

  Future<void> removePlan(DailyPlan plan) async {
    state.maybeWhen(
      loaded: (plans) {
        state = DailyPlanState.loaded(
          plans.where((p) => p.date != plan.date).toList(),
        );
      },
      orElse: () {},
    );
  }

  Future<void> updatePlan(DailyPlan plan) async {
    state.maybeWhen(
      loaded: (plans) {
        final filteredPlans = plans.where((p) => p.date != plan.date).toList();
        if (filteredPlans.isNotEmpty) {
          state = DailyPlanState.loaded([...filteredPlans, plan]);
        } else {
          state = DailyPlanState.loaded([plan]);
        }
      },
      orElse: () {
        state = DailyPlanState.loaded([plan]);
      },
    );
  }

  void setLoading() {
    state = const DailyPlanState.loading();
  }

  void setError(String message) {
    state = DailyPlanState.error(message);
  }
}

final dailyPlanProvider = StateNotifierProvider<DailyPlanNotifier, DailyPlanState>(
  (ref) => DailyPlanNotifier(),
); 