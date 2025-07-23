import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  /// Возвращает дату без времени
  DateTime get dateOnly => DateTime(year, month, day);

  /// Преобразует дату в строку-ключ для Hive: "YYYY-MM-DD"
  String get dateKey => '$day-$month-$year';

  /// Формат: 01.01.2024
  String formatDMY({String locale = 'ru'}) {
    return DateFormat('dd.MM.yyyy', locale).format(this);
  }
  String getDate() {
    return DateFormat('dd.MM.yyyy', 'ru').format(this);
  }

  String getDayWithDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    String textdDay = '';
    if (date == today) {
      textdDay = 'Сегодня';
    } else if (date == today.subtract(Duration(days: 1))) {
      textdDay = 'Вчера';
    } else {
      textdDay = _capitalize(DateFormat('EEEE', 'ru').format(this));
    }
    final formattedDate = DateFormat('d MMMM', 'ru').format(this);
    return '$textdDay, $formattedDate'; // "Вторник, 23 мая"
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

}
