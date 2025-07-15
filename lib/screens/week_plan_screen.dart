import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/widgets/day_list.dart';
import 'plan_screen.dart';
import 'meal_screen.dart';

class WeekPlanScreen extends ConsumerWidget {
  const WeekPlanScreen({super.key});

  void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanScreen(date: date)),
    );
  }

  void _navigateToMealScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MealScreen())
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Меню на неделю'),
          actions: [
            IconButton(onPressed: () => _navigateToMealScreen(context),
                icon: Icon(Icons.dining))
          ]),
      body: DayList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPlanEditor(null, context),
        child: Icon(Icons.add),
      ),
    );
  }
}