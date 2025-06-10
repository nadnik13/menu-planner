import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/widgets/expandable_fab.dart';

import '../screens/plan_editor.dart';
import '../screens/recipe_editor.dart';
import '../screens/recipes_screen.dart';

class ExpandableFabInteractor {
  static void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanEditor(date: date)),
    );
  }

  static void _navigateToMealScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeScreen()),
    );
  }

  static void _navigateToRecipeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeScreen()),
    );
    showDialog(context: context, builder: (_) => RecipeEditor(recipe: null));
  }

  static getExpandableFab(BuildContext context) => ExpandableFab(
    onAddDay: () => _navigateToPlanEditor(null, context),
    onAddDish: () => _navigateToMealScreen(context),
    onAddFood: () => _navigateToRecipeScreen(context),
  );
}
