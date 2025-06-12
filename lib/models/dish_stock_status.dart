import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'dish_stock_status.g.dart';

@HiveType(typeId: HiveTypeId.dishStockStatus)
enum DishStockStatus {
  @HiveField(0)
  added,
  @HiveField(1)
  done,
  @HiveField(2)
  planned
} 