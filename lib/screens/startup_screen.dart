import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_interactor.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_screen.dart';

/// ✅ УПРОЩЕННЫЙ StartupScreen - использует простой FutureProvider для загрузки
class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: _loadData(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загрузка данных...'),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const StartupScreen()),
                    ),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const DailyPlanScreen();
        }
      },
    );
  }

  /// ✅ Простая загрузка данных через Interactor
  Future<void> _loadData(WidgetRef ref) async {
    await ref.read(dishTemplateInteractorProvider).loadTemplates();
    // Здесь можно добавить загрузку других данных
    // await ref.read(dishStockInteractorProvider).loadStocks();
    // await ref.read(dailyPlanInteractorProvider).loadPlans();
  }
}
