extension DateUtils on DateTime {
  /// Возвращает дату без времени
  DateTime get dateOnly => DateTime(year, month, day);

  /// Преобразует дату в строку-ключ для Hive: "YYYY-MM-DD"
  String get dateKey => '$year-$month-$day';
}
