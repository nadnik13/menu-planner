import 'package:flutter/material.dart';
import '../../models/dish_stock.dart';
import '../../models/dish_stock_status.dart';

class StatusDropButton extends StatelessWidget {
  final DishStockStatus value;
  final ValueChanged<DishStockStatus> onChanged;

  const StatusDropButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DishStockStatus>(
      value: value,
      items: DishStockStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(_getStatusText(status)),
        );
      }).toList(),
      onChanged: (DishStockStatus? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  String _getStatusText(DishStockStatus status) {
    switch (status) {
      case DishStockStatus.planned:
        return 'Запланировано';
      case DishStockStatus.added:
        return 'В процессе';
      case DishStockStatus.done:
        return 'Готово';
    }
  }
}