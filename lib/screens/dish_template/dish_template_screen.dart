import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/models/dish_template.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_interactor.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_notifier.dart';
import 'package:my_recipe_app/screens/dish_template/dish_template_editor.dart';

/// ✅ УПРОЩЕННЫЙ экран шаблонов блюд - работает с простым Set<DishTemplate>
class DishTemplateScreen extends ConsumerWidget {
  const DishTemplateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Простое наблюдение за Set шаблонов
    final dishes = ref.watch(dishTemplateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Шаблоны блюд'),
        backgroundColor: const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: dishes.isEmpty
          ? const Center(child: Text('Нет шаблонов блюд'))
          : ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes.elementAt(index);
                return ListTile(
                  title: Text(dish.title),
                  subtitle: Text('${dish.portions} порций'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DishTemplateEditor(template: dish),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(context, ref, dish),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DishTemplateEditor(),
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, DishTemplate dish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить шаблон?'),
        content: Text('Удалить шаблон "${dish.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              ref.read(dishTemplateInteractorProvider).removeTemplate(dish);
              Navigator.pop(context);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
