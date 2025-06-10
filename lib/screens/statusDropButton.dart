import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logger.dart';
import '../models/meal_status_types.dart';
import '../providers/meal/meal_interactor.dart';

class StatusDropButton extends ConsumerStatefulWidget{
  final String mealId;
  final MealStatusType status;
  const StatusDropButton({
    super.key,
    required this.mealId,
    required this.status,
  });
  @override
  ConsumerState<StatusDropButton> createState() => _StatusDropButtonState();
}

class _StatusDropButtonState extends ConsumerState<StatusDropButton>{
  late MealStatusType selectedStatus;

  @override
  void initState() {
    super.initState();
    logger.d("_MyMealListState initState ${widget.status.label}");
    selectedStatus = widget.status;
  }

  @override
  void didUpdateWidget(covariant StatusDropButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Обновляем статус, если он изменился снаружи
    if (widget.status != oldWidget.status) {
      selectedStatus = widget.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("_MyMealListState build ${widget.status.label}");
    //final meal = ref.watch(mealProvider.notifier).getMealByKey(widget.mealId);
    //logger.d("_MyMealListState build ${meal?.title} ${meal?.status}");
    return DropdownButton<MealStatusType>(
      value: selectedStatus,
      isExpanded: false,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      onChanged: (MealStatusType? value) {
        if (value != null) {
          logger.d("_MyMealListState onChanged $value");
          setState(() {
            selectedStatus = value;
            ref.read(mealInteractorProvider).updateMealStatusByKey(key: widget.mealId, status: selectedStatus);
          });
        }
      },
      items: MealStatusType.values.map((status) {
        return DropdownMenuItem<MealStatusType>(
          value: status,
          child: Text(status.label),
        );
      }).toList(),
    );
  }
}