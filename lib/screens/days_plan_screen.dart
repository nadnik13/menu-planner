import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/widgets/day_list.dart';
import 'plan_editor.dart';
import 'meal_screen.dart';

class DaysPlanScreen extends ConsumerWidget {
  const DaysPlanScreen({super.key});

  void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanEditor(date: date)),
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
          title: Text('Дневник питания'),
          actions: [
            IconButton(onPressed: () => _navigateToMealScreen(context),
                icon: Image.asset('assets/images/plate.png', width: 60, height: 60))
          ]),
      body: DayList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPlanEditor(null, context),
        child: Icon(Icons.add),
      ),
    );
  }
}