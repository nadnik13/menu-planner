import '../models/recipe.dart';


class MealPlan{
  final Recipe recipe;
  final DateTime date;

  MealPlan({required this.date, required this.recipe});
}