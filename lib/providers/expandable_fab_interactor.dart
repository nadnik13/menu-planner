import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/widgets/expandable_fab.dart';

import '../screens/daily_plan/daily_plan_editor.dart';
import '../screens/dish_template/dish_template_editor.dart';
import '../screens/dish_template/dish_template_screen.dart';

class ExpandableFabInteractor {
  void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DailyPlanEditor(date: date)),
    );
  }

  void _navigateToMealScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DishTemplateScreen()),
    );
  }

  void _navigateToRecipeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DishTemplateScreen()),
    );
    showDialog(context: context, builder: (_) => DishTemplateEditor(template: null));
  }

  Widget getExpandableFab(BuildContext context) => ExpandableFab(
    onAddDay: () => _navigateToPlanEditor(null, context),
    onAddDish: () => _navigateToMealScreen(context),
    onAddFood: () => _navigateToRecipeScreen(context),
  );
}

final expandableFabInteractorProvider = StateProvider<ExpandableFabInteractor>(
  (ref) => ExpandableFabInteractor(),
); 