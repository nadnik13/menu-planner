import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../models/dish_template/dish_template.dart';
import 'interactor.dart';
import 'json_load_interactor.dart';
import 'notifier.dart';
import 'repository.dart';

abstract class DishTemplateProviders {
  DishTemplateProviders._();

  static final repository = Provider((ref) {
    final box = Hive.box<DishTemplate>('dishTemplateBox');
    return DishTemplateRepository(box);
  });

  static final jsonLoaderInteraptor = Provider<DishTemplateJsonLoadInteractor>((
    ref,
  ) {
    final bundle = rootBundle;
    return DishTemplateJsonLoadInteractor(bundle);
  });

  static final interactor = Provider<DishTemplateInteractor>((ref) {
    final notifier = ref.watch(provider.notifier);
    final jsonInteractor = ref.watch(jsonLoaderInteraptor);
    return DishTemplateInteractor(notifier, jsonInteractor);
  });

  static final provider =
      StateNotifierProvider<DishTemplateNotifier, Set<DishTemplate>>((ref) {
        final repo = ref.watch(DishTemplateProviders.repository);
        return DishTemplateNotifier(repo);
      });
}
