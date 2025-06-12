import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import '../../models/dish_stock.dart';

import '../../models/daily_plan.dart';
import '../../models/dish_stock_status_type.dart';
import '../../models/dish_template.dart';

Future<void> initializeApp() async {
  await initializeDateFormatting('ru');
  Logger.level = Level.debug;
  await Hive.initFlutter();
  Hive.registerAdapter(DishTemplateAdapter());
  Hive.registerAdapter(DishStockAdapter());
  Hive.registerAdapter(DailyPlanAdapter());
  Hive.registerAdapter(DishStockStatusTypeAdapter());

  await Hive.openBox<DishTemplate>('dishTemplateBox');
  await Hive.openBox<DishStock>('dishStockBox');
  await Hive.openBox<DailyPlan>('dailyPlanBox');
  await Hive.openBox<DailyPlan>('dishStockStatusTypeBox');
}


Future<void> clean() async {
  await Hive.deleteBoxFromDisk("dishTemplateBox");
  await Hive.deleteBoxFromDisk("dishStockBox");
  await Hive.deleteBoxFromDisk("dailyPlanBox");
  await Hive.openBox<DailyPlan>('dishStockStatusTypeBox');
}
