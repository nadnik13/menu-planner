import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/meal_plan_provider.dart';

class WeekPlanScreen extends ConsumerWidget {
  const WeekPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekPlans = ref.watch(weekPlanProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Меню на неделю')),
      body:
      weekPlans.isEmpty
          ? Center(child: Text('Нет запланированных блюд'))
          : ListView.builder(
        itemCount: weekPlans.length,
        itemBuilder: (context, index) {
          final planItem = weekPlans[index];
          final recipeDate = DateFormat('dd-MM-yyyy').format(planItem.date);
          return ListTile(
            title: Text(planItem.recipe.title),
            subtitle: Text('Дата: $recipeDate'),
            trailing: IconButton(
              onPressed: () {
                final planNotifier = ref.read(mealPlanProvider.notifier);
                planNotifier.removePlanByDate(planItem.date);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('План на $recipeDate удален.'),
                        action: SnackBarAction(
                          label: 'Отменить',
                          onPressed: () {
                            planNotifier.addOrReplacePlan(planItem);
                          },
                        )
                    ));
              },
              icon: Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
