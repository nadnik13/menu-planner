import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/widgets/expandable_fab.dart';

import '../screens/daily_plan/daily_plan_editor.dart';
import '../screens/dish_template/dish_template_editor.dart';
import '../screens/dish_template/dish_template_screen.dart';

class ExpandableFabInteractor {
  static void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanEditor(date: date)),
    );
  }

  static void _navigateToDishTemplateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DishTemplateScreen()),
    );
  }

  static void _navigateToTemplateEditorScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DishTemplateScreen()),
    );
    showDialog(context: context, builder: (_) => RecipeEditor(recipe: null));
  }

  static getExpandableFab(BuildContext context) => ExpandableFab(
    onAddDay: () => _navigateToPlanEditor(null, context),
    onAddDish: () => _navigateToDishTemplateScreen(context),
    onAddTemplate: () => _navigateToTemplateEditorScreen(context),
  );
}
