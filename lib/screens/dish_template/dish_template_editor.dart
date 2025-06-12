import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_template.dart';
import '../../providers/dish_template/dish_template_notifier.dart';

class DishTemplateEditor extends ConsumerStatefulWidget {
  final DishTemplate? template;

  const DishTemplateEditor({super.key, this.template});

  @override
  ConsumerState<DishTemplateEditor> createState() => _DishTemplateEditorState();
}

class _DishTemplateEditorState extends ConsumerState<DishTemplateEditor> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _portionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _nameController.text = widget.template!.title;
      _portionsController.text = widget.template!.portions.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portionsController.dispose();
    super.dispose();
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      final template = DishTemplate(
        id: widget.template?.id ?? DateTime.now().toString(),
        title: _nameController.text,
        portions: int.parse(_portionsController.text),
      );

      if (widget.template == null) {
        ref.read(dishTemplateProvider.notifier).addTemplate(template);
      } else {
        ref.read(dishTemplateProvider.notifier).addOrReplaceTemplate(template);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template == null ? 'Новый шаблон' : 'Редактирование'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название блюда',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portionsController,
                decoration: const InputDecoration(
                  labelText: 'Количество порций',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество порций';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Пожалуйста, введите число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTemplate,
                child: Text(widget.template == null ? 'Добавить' : 'Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
