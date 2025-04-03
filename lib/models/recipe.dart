import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

part 'recipe.g.dart';

@HiveType(typeId: HiveTypeId.recipe)
class Recipe {
  @HiveField(0)
  final String title;

  Recipe(this.title);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(json['title'] as String);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          other.title == title;

  @override
  int get hashCode => title.hashCode;
}
