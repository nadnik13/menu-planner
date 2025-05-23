import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/recipe/recipe_interactor.dart';
import 'package:my_recipe_app/widgets/save_button.dart';

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe?.title ?? "");
    _portion = widget.recipe?.portion ?? 1;
    isActive = _isValid;

    _titleController.addListener(_updateActiveState);
  }

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _portion > 0;

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
    ref.read(recipeInteractorProvider).addRecipe(title: title, portion: _portion);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Изменения сохранены')));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Редактировать рецепт"),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отмена'),
            ),
            SaveButton(isActive: isActive, onSave: _save),
          ],
        ),
      ],
    );
  }
}
