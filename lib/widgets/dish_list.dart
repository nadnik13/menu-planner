import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
import 'package:my_recipe_app/widgets/dish_card.dart';
import '../providers/dish_stock/dish_stock_provider.dart';
import '../utils/screen_utils.dart';
import 'package:collection/collection.dart';

class MealList extends ConsumerStatefulWidget {
  const MealList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MealListState();
}

class _MealListState extends ConsumerState<MealList> {
  @override
  Widget build(BuildContext context) {
    // Адаптивные отступы для карточек блюд
    final cardPadding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.all(12),   // iPhone 12 mini - компактнее
      medium: const EdgeInsets.all(16),  // iPhone 12/13/14 - стандартные  
      large: const EdgeInsets.all(20),   // Pro Max - больше
    );
    
    final isHideUnAvailableMeals = ref.watch(
      dailyPlanIsHideUnavailableStocksStateProvider,
    );
    final dish = ref.watch(dishStockProvider);
    final filteredDish =
        isHideUnAvailableMeals
            ? dish
                .where((e) => isHideUnAvailableMeals && e.availablePortion > 0)
            : dish;
    final sortedDishList = filteredDish.toList().sorted((a,b) => b.status.index.compareTo(a.status.index));
    
    if (dish.isEmpty) {
      return const Center(child: Text('Нет добавленных блюд'));
    } else if (sortedDishList.isEmpty) {
      return const Center(child: Text('Нет доступных блюд'));
    }
    
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: const [0.0, 0.00, 0.95, 1.0], // регулируй зону "видимости"
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        itemCount: sortedDishList.length,
        itemBuilder: (context, index) {
          final meal = sortedDishList[index];

          return Container(
            key: ValueKey(meal.id),
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: cardPadding, // Адаптивные отступы
            decoration: BoxDecoration(
              color: meal.status.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E5E5)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DishCard(meal),
          );
        },
      ),
    );
  }
}
