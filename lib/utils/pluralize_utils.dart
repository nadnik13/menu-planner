String pluralizePortion(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;

  if (mod10 == 1 && mod100 != 11) return "$count порция";
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
    return "$count порции";
  }
  return "$count порций";
}

String pluralizeDay(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;

  if (mod10 == 1 && mod100 != 11) return "$count день";
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
    return "$count дня";
  }
  return "$count дней";
}

String pluralizeDish(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;

  if (mod10 == 1 && mod100 != 11) return "$count блюдо";
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) {
    return "$count блюда";
  }
  return "$count блюд";
}
