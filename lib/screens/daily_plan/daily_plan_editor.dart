import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import '../../providers/core_providers.dart';
import '../../widgets/common_header.dart';
import '../../widgets/plan_editing_widget.dart';
import '../../utils/screen_utils.dart';

class PlanEditor extends ConsumerStatefulWidget {
  final DateTime date;
  final bool isAvailableChangeDate;

  const PlanEditor({
    super.key,
    required this.date,
    required this.isAvailableChangeDate,
  });

  @override
  ConsumerState<PlanEditor> createState() => PlanScreenState();
}

class PlanScreenState extends ConsumerState<PlanEditor> {
  int portion = 1;

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = ref.watch(CoreProviders.selectedDateProvider);

    // Адаптивные отступы
    final screenPadding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      // iPhone 12 mini
      medium: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
      // iPhone 12/13/14
      large: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 28,
      ), // Pro Max
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              const CommonHeader(title: 'Редактировать план'),
              const SizedBox(height: 20),
              _DatePickerRow(
                selectedDate: selectedDate,
                onDateChanged: (value) {
                  ref
                      .read(CoreProviders.selectedDateProvider.notifier)
                      .update(value);
                },
                isAvailableChangeDate: widget.isAvailableChangeDate,
              ),
              const SizedBox(height: 16),
              Expanded(child: PlanEditingWidget(selectedDate: selectedDate)),
              const SizedBox(height: 16),
            ],
          ),
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
    final formattedDate = selectedDate.formatDMY();
    return Row(
      children: [
        Expanded(
          child: Text(
            'Дата: $formattedDate',
            style: TextStyle(
              fontSize: ScreenUtils.adaptiveFontSize(
                context,
                small: 16.0, // iPhone 12 mini
                medium: 18.0, // iPhone 12/13/14
                large: 20.0, // Pro Max
              ),
              fontWeight: FontWeight.w500,
            ),
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
            icon: const Icon(Icons.edit, color: Color(0xFF0F676E)),
          ),
      ],
    );
  }
}
