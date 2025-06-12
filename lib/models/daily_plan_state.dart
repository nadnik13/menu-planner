import 'package:freezed_annotation/freezed_annotation.dart';
import 'daily_plan.dart';

part 'daily_plan_state.freezed.dart';

@freezed
class DailyPlanState with _$DailyPlanState {
  const factory DailyPlanState.initial() = _Initial;
  const factory DailyPlanState.loading() = _Loading;
  const factory DailyPlanState.loaded(List<DailyPlan> plans) = _Loaded;
  const factory DailyPlanState.error(String message) = _Error;
} 