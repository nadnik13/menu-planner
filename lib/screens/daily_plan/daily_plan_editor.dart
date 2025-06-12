import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/daily_plan.dart';
import '../../providers/daily_plan/daily_plan_notifier.dart';
import '../../providers/selected_date_notifier.dart';
import '../../core/logger.dart';
import '../../widgets/common_header.dart';
import '../../widgets/dish_editor.dart';

class DailyPlanEditor extends ConsumerStatefulWidget {
  final DateTime? date;

  const DailyPlanEditor({Key? key, this.date}) : super(key: key);

  @override
  ConsumerState<DailyPlanEditor> createState() => _DailyPlanEditorState();
}

class _DailyPlanEditorState extends ConsumerState<DailyPlanEditor> {
  @override
  void initState() {
    super.initState();
    logger.d("DailyPlanEditor initState ${widget.date}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final date = widget.date;
      if (date != null) {
        ref.read(selectedDateProvider.notifier).update(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d("DailyPlanEditor build selectedDate: ${widget.date}");
    final DateTime selectedDate = ref.watch(selectedDateProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
        child: Column(
          children: [
            const CommonHeader(title: 'Редактировать план'),
            SizedBox(height: 20),
            _DatePickerRow(
              selectedDate: selectedDate,
              onDateChanged: (value) {
                ref.read(selectedDateProvider.notifier).update(value);
              },
              isAvailableChangeDate: widget.date == null,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DishEditor(selectedDate: selectedDate)
            ),
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
    final formattedDate = selectedDate.toString().split(' ')[0];
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
