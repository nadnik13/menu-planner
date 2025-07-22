import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  final DateTime initialDate;

  SelectedDateNotifier(this.initialDate);

  @override
  DateTime build() => initialDate;

  void update(DateTime newDate) {
    state = newDate;
  }
}
