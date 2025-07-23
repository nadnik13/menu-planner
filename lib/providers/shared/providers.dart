import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/providers/shared/selected_date_notifier.dart';

import '../daily_plan/view_interactor.dart';
import 'expandable_fab_interactor.dart';

abstract class SharedProviders {
  SharedProviders._();

  static final tabIndexProvider =
      StateNotifierProvider<TabIndexProviderNotifier, int>(
        (ref) => TabIndexProviderNotifier(),
      );

  static final selectedDateProvider =
      NotifierProvider<SelectedDateNotifier, DateTime>(
        () =>
            throw UnimplementedError(
              'Провайдер должен быть переопределен в дочернем скоупе',
            ),
      );

  static final expandableFabInteractor = Provider<ExpandableFabInteractor>((
      ref,
      ) {
    return ExpandableFabInteractor();
  });
}
