import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import '../../providers/shared/providers.dart';
import '../../widgets/common_header.dart';
import '../../widgets/plan_editing_widget.dart';
import '../../utils/screen_utils.dart';

class PlanEditor extends ConsumerStatefulWidget {
  final bool _isAvailableChangeDate;

  const PlanEditor({
    super.key,
    required bool isAvailableChangeDate,
  }) : _isAvailableChangeDate = isAvailableChangeDate;

  @override
  ConsumerState<PlanEditor> createState() => PlanScreenState();
}

class PlanScreenState extends ConsumerState<PlanEditor> {

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = ref.watch(SharedProviders.selectedDateProvider);

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
                      .read(SharedProviders.selectedDateProvider.notifier)
                      .update(value);
                },
                isAvailableChangeDate: widget._isAvailableChangeDate,
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
  final DateTime _selectedDate;
  final ValueChanged<DateTime> _onDateChanged;
  final bool _isAvailableChangeDate;

  const _DatePickerRow({
    required DateTime selectedDate,
    required void Function(DateTime) onDateChanged,
    required bool isAvailableChangeDate,
  }) : _isAvailableChangeDate = isAvailableChangeDate, _onDateChanged = onDateChanged, _selectedDate = selectedDate;

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate.formatDMY();
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
        if (_isAvailableChangeDate)
          IconButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: _selectedDate.subtract(const Duration(days: 60)),
                lastDate: _selectedDate.add(const Duration(days: 305)),
              );
              if (picked != null) {
                _onDateChanged(picked);
              }
            },
            icon: const Icon(Icons.edit, color: Color(0xFF0F676E)),
          ),
      ],
    );
  }
}
