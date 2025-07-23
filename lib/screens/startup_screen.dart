import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/screens/daily_plan/daily_plan_screen.dart';

import '../providers/daily_plan/providers.dart';
import '../providers/dish_stock/providers.dart';
import '../providers/dish_template/providers.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<void> loadData(WidgetRef ref) async {
    await ref.read(DishTemplateProviders.interactor).load();
    await ref.read(DishStockProviders.interactor).loadValues();
    await ref.read(DailyPlanProviders.interactor).loadValues();
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
              return const DailyPlanScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
