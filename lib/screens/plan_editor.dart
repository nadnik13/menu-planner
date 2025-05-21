import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/selected_date_notifier.dart';
import '../widgets/meal_list.dart';

class PlanScreen extends ConsumerStatefulWidget {
  final DateTime? date;

  const PlanScreen({super.key, this.date});

  @override
  ConsumerState<PlanScreen> createState() => PlanScreenState();
}

class PlanScreenState extends ConsumerState<PlanScreen> {
  int portion = 1;

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = widget.date??ref.watch(selectedDateProvider);
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
              isAvailableChangeDate: widget.date == null,
            ),
            const SizedBox(height: 16),
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
  final bool isAvailableChangeDate;

  const _DatePickerRow({
    required this.selectedDate,
    required this.onDateChanged,
    required this.isAvailableChangeDate,
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
        if (isAvailableChangeDate)
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
