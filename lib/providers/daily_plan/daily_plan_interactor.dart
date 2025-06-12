import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/daily_plan.dart';
import 'daily_plan_notifier.dart';
import 'daily_plan_repository.dart';

class DailyPlanInteractor {
  final Ref ref;
  final DailyPlanRepository _repository;

  DailyPlanInteractor(this.ref, this._repository);

  Future<void> loadPlans() async {
    try {
      ref.read(dailyPlanProvider.notifier).setLoading();
      final plans = await _repository.loadPlans();
      ref.read(dailyPlanProvider.notifier).loadPlans(plans);
    } catch (e) {
      ref.read(dailyPlanProvider.notifier).setError(e.toString());
    }
  }

  Future<void> savePlan(DailyPlan plan) async {
    try {
      await _repository.savePlan(plan);
      await ref.read(dailyPlanProvider.notifier).addPlan(plan);
    } catch (e) {
      ref.read(dailyPlanProvider.notifier).setError(e.toString());
    }
  }

  Future<void> removePlan(DailyPlan plan) async {
    try {
      await _repository.deletePlan(plan);
      await ref.read(dailyPlanProvider.notifier).removePlan(plan);
    } catch (e) {
      ref.read(dailyPlanProvider.notifier).setError(e.toString());
    }
  }
}

final dailyPlanInteractorProvider = Provider<DailyPlanInteractor>((ref) {
  final repository = ref.watch(dailyPlanRepositoryProvider);
  return DailyPlanInteractor(ref, repository);
}); 