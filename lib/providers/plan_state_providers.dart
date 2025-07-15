import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void update(DateTime newDate) {
    state = newDate;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  () {
    return SelectedDateNotifier();
  },
);
//:TODO не показывать значения где нет доступных порций
final selectedMealProvider = StateProvider<Meal?>((ref) => null);
