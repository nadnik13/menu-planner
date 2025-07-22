import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/core/navigation/app_routes.dart';
import 'package:food_planner/screens/daily_plan/daily_plan_editor.dart';
import 'package:food_planner/screens/daily_plan/daily_plan_screen.dart';
import 'package:food_planner/screens/dish_template/dish_template_screen.dart';
import 'package:food_planner/screens/startup_screen.dart';

import 'core/extensions/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F676E)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5AAE6D),
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const StartupScreen(),
    );
  }
}
