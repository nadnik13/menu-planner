import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/widgets/styled_button.dart';

import '../../models/dish_template/dish_template.dart';
import '../../providers/dish_template/dish_template_providers.dart';

class DishTemplateEditor extends ConsumerStatefulWidget {
  final DishTemplate? template;

  const DishTemplateEditor({super.key, required this.template});

  //:TODO можно ли оставить рецепт в параметрах
  @override
  ConsumerState<DishTemplateEditor> createState() => _RecipeEditorState();
}

class _RecipeEditorState extends ConsumerState<DishTemplateEditor> {
  late TextEditingController _titleController;
  late int _portion;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.template?.title ?? "",
    );
    _portion = widget.template?.portion ?? 1;
    _isActive = _isValid;

    _titleController.addListener(_updateActiveState);
  }

  bool get _isValid => _titleController.text.trim().isNotEmpty && _portion > 0;

  void _updateActiveState() {
    final valid = _isValid;
    if (valid != _isActive) {
      setState(() {
        _isActive = valid;
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();

    ref
        .read(DishTemplateProviders.interactor)
        .addOrReplace(id: widget.template?.id, title: title, portion: _portion);

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
                Expanded(child: Text('Кол-во порций')),
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
              child: StyledButton(
                onPress: _cancel,
                isActive: true,
                text: 'Отмена',
                type: ButtonType.light,
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: StyledButton(
                isActive: _isActive,
                onPress: _save,
                text: 'Сохранить',
                type: ButtonType.dark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
