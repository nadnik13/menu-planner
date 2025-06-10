import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/providers/recipe/recipe_interactor.dart';
import 'package:my_recipe_app/widgets/styled_button.dart';

import '../models/recipe.dart';

class RecipeEditor extends ConsumerStatefulWidget {
  final Recipe? recipe;

  const RecipeEditor({super.key, required this.recipe});

  //:TODO можно ли оставить рецепт в параметрах
  @override
  ConsumerState<RecipeEditor> createState() => _RecipeEditorState();
}

class _RecipeEditorState extends ConsumerState<RecipeEditor> {
  late TextEditingController _titleController;
  late int _portion;
  bool isActive = false;
  late bool isNewFood;

  @override
  void initState() {
    super.initState();
    logger.d('_RecipeEditorState.initState');
    _titleController = TextEditingController(text: widget.recipe?.title ?? "");
    isNewFood = widget.recipe?.title != null ? false : true;
    _portion = widget.recipe?.portion ?? 1;
    isActive = _isValid;

    _titleController.addListener(_updateActiveState);
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty && _portion > 0;

  void _updateActiveState() {
    final valid = _isValid;
    if (valid != isActive) {
      setState(() {
        isActive = valid;
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    ref
        .read(recipeInteractorProvider)
        .addRecipe(title: title, portion: _portion);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Изменения сохранены')));
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Редактор", textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Название'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Кол-во порций'),
                IconButton(
                  onPressed:
                      _portion > 1 ? () => setState(() => _portion--) : null,
                  icon: Icon(Icons.remove),
                ),
                Text('$_portion'),
                IconButton(
                  onPressed:
                      _portion < 99 ? () => setState(() => _portion++) : null,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child:
                StyledButton(
              onPress: _cancel,
              isActive: true,
              text: 'Отмена',
              type: ButtonType.light,
            )),
             SizedBox(width: 4),
             Expanded(
                 child: StyledButton(
               isActive: isActive,
               onPress: _save,
               text: 'Сохранить',
               type: ButtonType.dark,
             )
             ),
          ],
        ),
      ],
    );
  }
}
