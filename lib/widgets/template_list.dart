import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dish_template/dish_template.dart';
import '../providers/dish_template/dish_template_notifier.dart';
import '../utils/emoji_utils.dart';

class TemplateList extends ConsumerWidget {
  final void Function(DishTemplate) onRemove;
  final void Function(DishTemplate) onEdit;
  final void Function(DishTemplate) onAdd;
  final String searchQuery;

  const TemplateList({
    super.key,
    required this.onRemove,
    required this.onAdd,
    required this.onEdit,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(dishTemplateProvider);
    if (templates.isEmpty) {
      return const Center(child: Text('Нет добавленных блюд'));
    }
    final filteredTemplates =
        templates.where((recipe) {
          return recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

    if (filteredTemplates.isEmpty) {
      return const Center(child: Text('Ничего не найдено'));
    }

    return ListView.builder(
      itemCount: filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = filteredTemplates[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E5E5)),
            boxShadow: [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getEmojiForMeal(template.title),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                template.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onEdit(template),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => onRemove(template),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'По умолчанию: ${template.portion} порции',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => onAdd(template),
                child: Text(
                  'Добавить в запасы >',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
