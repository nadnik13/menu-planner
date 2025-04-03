import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/meal_plan_provider.dart';
import 'package:intl/intl.dart';

class WeekPlanScreen extends ConsumerWidget {
  const WeekPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(mealPlanProvider.notifier).getPlanForWeek();

    return Scaffold(
      appBar: AppBar(title: Text('Меню на неделю')),
      body:
          plan.isEmpty
              ? Center(child: Text('Нет запланированных блюд'))
              : ListView.builder(
                  itemCount: plan.length,
                  itemBuilder: (context, index) {
                    final planItem = plan[index];
                    final recipeDate = DateFormat(
                      'dd.MM.yyyy',
                    ).format(planItem.date);
                    return ListTile(
                      title: Text(planItem.recipe.title),
                      subtitle: Text('Дата: $recipeDate'),
                      trailing: IconButton(
                          onPressed: () =>
                            ref.read(mealPlanProvider.notifier).removePlan(planItem),
                          icon: Icon(Icons.delete)),
                    );
                  },
                ),
    );
  }
}
