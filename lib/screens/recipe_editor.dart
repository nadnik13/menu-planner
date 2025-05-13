import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/recipe/recipe_provider.dart';
import 'package:my_recipe_app/widgets/save_button.dart';

import '../models/recipe.dart';

class RecipeEditor extends ConsumerStatefulWidget {
  final Recipe? recipe;

  const RecipeEditor({super.key, required this.recipe});

  ConsumerState<RecipeEditor> createState() => _RecipeEditorState(recipe);
}

class _RecipeEditorState extends ConsumerState<RecipeEditor> {
  final Recipe? recipe;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late int _portion;
  bool isActive = false;
  String? selectedMeal;
  final List<String> mealTypes = ['Завтрак', 'Обед', 'Ужин', 'Перекус'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe?.title ?? "");
    _descController = TextEditingController(
      text: widget.recipe?.description ?? "",
    );
    _portion = widget.recipe?.portion ?? 1;

    isActive = _isValid;

    _titleController.addListener(_updateActiveState);
    _descController.addListener(_updateActiveState);
  }

  bool get _isValid =>
     _titleController.text.trim().isNotEmpty &&
        _descController.text.trim().isNotEmpty
        && selectedMeal != null
  && _portion > 0;


  void _updateActiveState() {
    final valid = _isValid;
    if (valid != isActive) {
      setState(() {
        isActive = valid;
      });
    }
  }

  void _save() {
    //:TODO Возможно стоит вынести логику добавления рецепта и в pop посылать результат
    Navigator.of(context).pop();

    final editedRecipe = Recipe.add(
      _titleController.text.trim(),
      _descController.text.trim(),
      _portion
    );
    ref.read(recipeProvider.notifier).addOrReplaceRecipe(editedRecipe);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Изменения сохранены')));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  _RecipeEditorState(this.recipe);

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
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: 'Описание'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMeal,
              decoration: const InputDecoration(
                labelText: "Приём пищи",
                border: OutlineInputBorder(),
              ),
              items:
                  mealTypes.map((meal) {
                    return DropdownMenuItem<String>(
                      value: meal,
                      child: Text(meal),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMeal = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Кол-во порций'),
                IconButton(onPressed: _portion > 1 ? () => setState( () => _portion--) : null,
                    icon: Icon(Icons.remove)),
                Text('$_portion'),
                IconButton(onPressed: _portion < 99 ? () => setState( () => _portion++) : null,
                    icon: Icon(Icons.add)),
              ]
            )
          ],
        )),
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
