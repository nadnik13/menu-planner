import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../hive_type_ids.dart';

part 'dish_template.g.dart';

@HiveType(typeId: HiveTypeId.dishTemplate)
class DishTemplate {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(3)
  final int portion;

  DishTemplate(this.id, this.title, this.portion);

  static final List<String> types = ['Завтрак', 'Обед', 'Ужин', 'Перекус'];

  factory DishTemplate.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final title = json['title'] as String;

    // Безопасно парсим portion - может быть строкой или числом
    final portionValue = json['portion'];
    int portion;
    if (portionValue is String) {
      portion = int.parse(portionValue);
    } else if (portionValue is int) {
      portion = portionValue;
    } else {
      portion = 1; // значение по умолчанию
    }

    return DishTemplate(id, title, portion);
  }

  factory DishTemplate.add({
    String? id,
    required String title,
    required int portion,
  }) => DishTemplate(id ?? Uuid().v4(), title, portion);

  static DishTemplate get empty => DishTemplate("", "", 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DishTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
