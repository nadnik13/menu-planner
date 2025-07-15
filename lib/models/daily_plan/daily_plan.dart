import 'package:my_recipe_app/core/extensions/date_extensions.dart';

import 'package:hive/hive.dart';
import '../hive_type_ids.dart';

part 'daily_plan.g.dart';

@HiveType(typeId: HiveTypeId.dailyPlan)
class DailyPlan {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final Map<String, int> portions;

  DailyPlan({required this.date, required this.portions});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DailyPlan &&
            portions.length == other.portions.length &&
            date.dateOnly == other.date.dateOnly &&
            portions == other.portions);
  }

  @override
  int get hashCode => Object.hash(date.dateOnly, portions);
}
