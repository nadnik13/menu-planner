import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_interactor.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_screen.dart';

import '../providers/dish_template/dish_template_interactor.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<void> loadData(WidgetRef ref) async {
    await ref.read(dishTemplateInteractorProvider).load();
    await ref.read(dishStockInteractorProvider).loadValues();
    await ref.read(dailyPlanInteractorProvider).loadValues();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: loadData(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Ошибка: ${snapshot.error}')),
              );
            } else {
              return const DaysPlanScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
