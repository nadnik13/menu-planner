import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import '../firebase_options.dart';
import '../models/dish_stock/dish_stock.dart';
import '../models/daily_plan/daily_plan.dart';
import '../models/dish_stock/dish_stock_status_types.dart';
import '../models/dish_template/dish_template.dart';

class AppInitializer {
  AppInitializer._(); // Приватный конструктор

  static Future<void> initialize() async {
    await initializeDateFormatting('ru');
    Logger.level = Level.debug;

    // Инициализация Hive
    await Hive.initFlutter();
    Hive.registerAdapter(DishTemplateAdapter());
    Hive.registerAdapter(DishStockAdapter());
    Hive.registerAdapter(DailyPlanAdapter());
    Hive.registerAdapter(DishStockStatusTypeAdapter());

    await Hive.openBox<DishTemplate>('dishTemplateBox');
    await Hive.openBox<DishStock>('dishStockBox');
    await Hive.openBox<DailyPlan>('dailyPlanBox');
    await Hive.openBox('dishStockStatusTypeBox');

    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  static Future<void> cleanStorage() async {
    await Hive.deleteBoxFromDisk("dishTemplateBox");
    await Hive.deleteBoxFromDisk("dishStockBox");
    await Hive.deleteBoxFromDisk("dailyPlanBox");
    await Hive.deleteBoxFromDisk("dishStockStatusTypeBox");
  }

  static Future<void> dispose() async {
    await Hive.close();
  }
}