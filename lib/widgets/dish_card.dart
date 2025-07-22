import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dish_stock/dish_stock.dart';
import '../providers/dish_stock/dish_stock_providers.dart';
import 'status_drop_button.dart';
import '../utils/emoji_utils.dart';
import '../utils/screen_utils.dart';

class DishCard extends ConsumerWidget {
  final DishStock _meal;
  const DishCard(this._meal, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getEmojiForMeal(_meal.title),
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
                    _meal.title,
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
                    'Порций: ${_meal.addedCntPortion} (план ${_meal.usedCntPortion})',
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
              onPressed: () => ref.read(DishStockProviders.removeInteractor).remove(_meal),
              icon: const Icon(Icons.delete, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        //:TODO надо оonChange выносить не знаю как
        StatusDropButton(mealId: _meal.id, status: _meal.status),
      ],
    );
  }
}
