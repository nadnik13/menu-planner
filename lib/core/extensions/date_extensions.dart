import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  /// Возвращает дату без времени
  DateTime get dateOnly => DateTime(year, month, day);

  /// Преобразует дату в строку-ключ для Hive: "YYYY-MM-DD"
  String get dateKey => '$day-$month-$year';

  /// Формат: Понедельник, 1 Января
  String formatWithDayWeek({String locale = 'ru'}) {
    return DateFormat('EEEE, d MMMM', locale).format(this);
  }

  /// Формат: 01.01.2024
  String formatDMY({String locale = 'ru'}) {
    return DateFormat('dd.MM.yyyy', locale).format(this);
  }
}
