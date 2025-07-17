import 'package:flutter/material.dart';
import 'package:food_planner/core/navigation/app_routes.dart';
import 'package:food_planner/widgets/expandable_fab.dart';

import '../screens/dish_template/dish_template_editor.dart';

class ExpandableFabInteractor {
  static void _navigateToPlanEditor(DateTime? date, BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.dailyPlanEditor, arguments: date);
  }

  static void _navigateToDishTemplateScreen(BuildContext context) {
    Navigator.pushNamed(
        context,
        AppRoutes.dishTemplates
    );
  }

  static void _navigateToTemplateEditorScreen(BuildContext context) {
    if (ModalRoute
        .of(context)
        ?.settings
        .name != AppRoutes.dishTemplates) {
      Navigator.pushNamed(context, AppRoutes.dishTemplates);
    }
    showDialog(
      context: context,
      builder: (_) => DishTemplateEditor(template: null),
    );
  }

  static getExpandableFab({required int type, required BuildContext context}) {
    switch (type) {
      case 1:
        return ExpandableFab(
          icons: [const Icon(Icons.calendar_today), const Icon(Icons.cookie),],
          labels: ['План на день', ' Еда'],
          callbacks: [
                () => _navigateToPlanEditor(null, context),
                () => _navigateToDishTemplateScreen(context)
          ]);
      case 2:
        return ExpandableFab(icons: [const Icon(Icons.fastfood)], labels: ['Добавить еду',], callbacks: [() => _navigateToTemplateEditorScreen(context),]);
      default: return ExpandableFab(icons: [], labels: [], callbacks: []);
    }
  }
}