import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

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
final selectedRecipeProvider = StateProvider<Recipe?>((ref) => null);
