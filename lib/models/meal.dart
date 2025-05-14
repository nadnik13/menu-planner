import 'package:hive/hive.dart';
import 'package:my_recipe_app/models/recipe.dart';
import 'package:uuid/uuid.dart';

import 'hive_type_ids.dart';

part 'meal.g.dart';

@HiveType(typeId: HiveTypeId.meal)
class Meal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? recipeId;

  @HiveField(3)
  final int addedCntPortion;

  @HiveField(4)
  final int usedCntPortion;

  Meal(
    this.id,
    this.title,
    this.recipeId,
    this.addedCntPortion,
    this.usedCntPortion,
  );

  factory Meal.add(Recipe recipe) {
    final uuid = Uuid();
    final id = uuid.v4();
    return Meal(id, recipe.title, recipe.id, recipe.portion, 0);
  }

  int get availablePortion => addedCntPortion - usedCntPortion;

  Meal copyWith({int? addedCntPortion, int? usedCntPortion}) {
    return Meal(
      id,
      title,
      recipeId,
      addedCntPortion ?? this.addedCntPortion,
      usedCntPortion ?? this.usedCntPortion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Meal && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
