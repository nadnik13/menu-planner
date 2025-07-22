import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dish_template/dish_template.dart';
import '../providers/dish_template/dish_template_providers.dart';
import '../utils/emoji_utils.dart';
import '../utils/screen_utils.dart';

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
    // Адаптивные отступы для карточек - только вертикальные, горизонтальные контролируются экраном
    final cardMargin = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),   // iPhone 12 mini - без горизонтальных отступов
      medium: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),  // iPhone 12/13/14 - без горизонтальных отступов
      large: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),   // Pro Max - без горизонтальных отступов
    );
    
    final cardPadding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.all(12),   // iPhone 12 mini - компактнее
      medium: const EdgeInsets.all(16),  // iPhone 12/13/14 - стандартные  
      large: const EdgeInsets.all(20),   // Pro Max - просторнее
    );
    
    final templates = ref.watch(DishTemplateProviders.provider);
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
          margin: cardMargin, // Адаптивные внешние отступы
          padding: cardPadding, // Адаптивные внутренние отступы
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
                    style: TextStyle(
                      fontSize: ScreenUtils.adaptiveFontSize(
                        context,
                        small: 24.0,   // iPhone 12 mini - меньше
                        medium: 30.0,  // iPhone 12/13/14 - стандартный
                        large: 32.0,   // Pro Max - больше
                      ),
                    ),
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
                                style: TextStyle(
                                  fontSize: ScreenUtils.adaptiveFontSize(
                                    context,
                                    small: 18.0,   // iPhone 12 mini
                                    medium: 20.0,  // iPhone 12/13/14
                                    large: 22.0,   // Pro Max
                                  ),
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
                            fontSize: ScreenUtils.adaptiveFontSize(
                              context,
                              small: 15.0,   // iPhone 12 mini
                              medium: 17.0,  // iPhone 12/13/14
                              large: 18.0,   // Pro Max
                            ),
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
                    fontSize: ScreenUtils.adaptiveFontSize(
                      context,
                      small: 15.0,   // iPhone 12 mini
                      medium: 17.0,  // iPhone 12/13/14
                      large: 18.0,   // Pro Max
                    ),
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
