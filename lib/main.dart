import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/navigation/app_routes.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_editor.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_screen.dart';
import 'package:my_recipe_app/screens/dish_template/dish_template_screen.dart';
import 'package:my_recipe_app/screens/startup_screen.dart';

import 'core/extensions/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.dailyPlan,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.dailyPlan:
            return MaterialPageRoute(
              builder: (_) => const DailyPlanScreen(),
              settings: settings,
            );
          case AppRoutes.dailyPlanEditor:
            final date = settings.arguments as DateTime?;
            return MaterialPageRoute(
              builder: (_) => PlanEditor(date: date),
              settings: settings,
            );
          case AppRoutes.dishTemplates:
            return MaterialPageRoute(builder: (_) => DishTemplateScreen(),
            settings: settings);
        }
        return null;
      },
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent, // или любой другой основной цвет
          shape:
              const CircleBorder(), // 👈 Возвращает стандартную круглую форму
        ),
      ),
      home: const StartupScreen(),
    );
  }
}
