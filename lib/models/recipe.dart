import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'hive_type_ids.dart';

part 'recipe.g.dart';

@HiveType(typeId: HiveTypeId.recipe)
class Recipe {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(3)
  final int portion;

  Recipe(this.id, this.title, this.portion);
  static final List<String> types = ['Завтрак', 'Обед', 'Ужин', 'Перекус'];

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return Recipe(
      id,
      json['title'] as String,
      json['portion'] as int,
    );
  }

  factory Recipe.add({
    String? id,
    required String title,
    required int portion,
  }) => Recipe(id ?? Uuid().v4(), title, portion);

  static Recipe get empty => Recipe("", "", 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Recipe && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
