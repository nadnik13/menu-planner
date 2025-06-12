import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dish_stock/dish_stock.dart';
import '../providers/dish_stock/dish_stock_remove_interactor.dart';
import '../screens/statusDropButton.dart';
import '../utils/emoji_utils.dart';

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
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Порций: ${meal.addedCntPortion} (план ${meal.usedCntPortion})',
                    style: TextStyle(
                      fontSize: 17,
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
