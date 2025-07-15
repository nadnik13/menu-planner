import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/logger.dart';
import '../models/dish_stock/dish_stock_status_types.dart';
import '../providers/dish_stock/dish_stock_interactor.dart';

class StatusDropButton extends ConsumerStatefulWidget{
  final String mealId;
  final DishStockStatusType status;
  const StatusDropButton({
    super.key,
    required this.mealId,
    required this.status,
  });
  @override
  ConsumerState<StatusDropButton> createState() => _StatusDropButtonState();
}

class _StatusDropButtonState extends ConsumerState<StatusDropButton>{
  late DishStockStatusType selectedStatus;

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
    //final dish_stock = ref.watch(mealProvider.notifier).getMealByKey(widget.mealId);
    //logger.d("_MyMealListState build ${dish_stock?.title} ${dish_stock?.status}");
    return DropdownButton<DishStockStatusType>(
      value: selectedStatus,
      isExpanded: false,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      onChanged: (DishStockStatusType? value) {
        if (value != null) {
          logger.d("_MyMealListState onChanged $value");
          setState(() {
            selectedStatus = value;
            ref.read(dishStockInteractorProvider).updateStatusByKey(key: widget.mealId, status: selectedStatus);
          });
        }
      },
      items: DishStockStatusType.values.map((status) {
        return DropdownMenuItem<DishStockStatusType>(
          value: status,
          child: Text(status.label),
        );
      }).toList(),
    );
  }
}