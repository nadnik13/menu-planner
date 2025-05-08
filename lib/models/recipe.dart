import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

part 'recipe.g.dart';

@HiveType(typeId: HiveTypeId.recipe)
class Recipe {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  Recipe(this.id, this.title, this.description);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return Recipe(id, json['title'] as String, json['description'] as String?);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe && runtimeType == other.runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
