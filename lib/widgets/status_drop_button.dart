import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logger.dart';
import '../models/dish_stock/dish_stock_status_types.dart';
import '../providers/dish_stock/providers.dart';

class StatusDropButton extends ConsumerStatefulWidget {
  final String _mealId;
  final DishStockStatusType _status;

  const StatusDropButton({
    super.key,
    required String mealId,
    required DishStockStatusType status,
  }) : _status = status,
       _mealId = mealId;

  @override
  ConsumerState<StatusDropButton> createState() => _StatusDropButtonState();
}

class _StatusDropButtonState extends ConsumerState<StatusDropButton> {
  late DishStockStatusType _selectedStatus;

  @override
  void initState() {
    super.initState();
    logger.d("_MyMealListState initState ${widget._status.label}");
    _selectedStatus = widget._status;
  }

  @override
  void didUpdateWidget(covariant StatusDropButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.d(
      "didUpdateWidget ${oldWidget.key}, ${oldWidget._mealId} ${oldWidget._status} ${widget._status} ",
    );

    // Обновляем статус, если он изменился снаружи
    if (widget._status != oldWidget._status) {
      _selectedStatus = widget._status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DishStockStatusType>(
      value: _selectedStatus,
      isExpanded: false,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      onChanged: (DishStockStatusType? value) {
        if (value != null) {
          logger.d("_MealListState changed: $value");
          setState(() {
            _selectedStatus = value;
            ref
                .read(DishStockProviders.interactor)
                .updateStatusByKey(
                  key: widget._mealId,
                  status: _selectedStatus,
                );
          });
        }
      },
      items:
          DishStockStatusType.values.map((status) {
            return DropdownMenuItem<DishStockStatusType>(
              value: status,
              child: Text(status.label),
            );
          }).toList(),
    );
  }
}
