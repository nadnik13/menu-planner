import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/plan_state_providers.dart';
import '../models/meal.dart';
import '../widgets/meal_list.dart';

class PlanScreen extends ConsumerStatefulWidget {
  final Meal? meal;

  const PlanScreen({super.key, this.meal});

  @override
  ConsumerState<PlanScreen> createState() => PlanScreenState(meal);
}

class PlanScreenState extends ConsumerState<PlanScreen> {
  final Meal? meal;
  int portion = 1;

  PlanScreenState(this.meal);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedMealProvider.notifier).state = meal;
    });
  }

  @override
  Widget build(BuildContext context) {
    //:TODO это явно должно выглядеть как-то иначе в итоге
    final selectedDate = ref.watch(selectedDateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('План')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _DatePickerRow(
              selectedDate: selectedDate,
              onDateChanged: (value) {
                ref.read(selectedDateProvider.notifier).update(value);
              },
            ),
            const SizedBox(height: 16),
            //MealList(key: ValueKey(selectedDate), selectedDate: selectedDate),
            MealList(selectedDate: selectedDate),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DatePickerRow({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate.dateKey;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Дата: $formattedDate',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: selectedDate.subtract(const Duration(days: 60)),
              lastDate: selectedDate.add(const Duration(days: 305)),
            );
            if (picked != null) {
              onDateChanged(picked);
            }
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}
