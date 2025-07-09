import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dish_stock/dish_stock.dart';
import '../providers/dish_stock/dish_stock_remove_interactor.dart';
import 'status_drop_button.dart';
import '../utils/emoji_utils.dart';
import '../utils/screen_utils.dart';

class DishCard extends ConsumerWidget {
  final DishStock meal;
  const DishCard(this.meal, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getEmojiForMeal(meal.title),
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
                  Text(
                    meal.title,
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
                  const SizedBox(height: 4),
                  Text(
                    'Порций: ${meal.addedCntPortion} (план ${meal.usedCntPortion})',
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
            IconButton(
              onPressed: () => ref.read(dishStockRemoveInteractorProvider).remove(meal),
              icon: const Icon(Icons.delete, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        //:TODO надо оonChange выносить не знаю как
        StatusDropButton(mealId: meal.id, status: meal.status),
      ],
    );
  }
}
