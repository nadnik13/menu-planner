import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
import 'package:my_recipe_app/widgets/dish_card.dart';
import '../providers/dish_stock/dish_stock_provider.dart';

class MealList extends ConsumerStatefulWidget {
  const MealList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MealListState();
}

class _MealListState extends ConsumerState<MealList> {
  @override
  Widget build(BuildContext context) {
    final isHideUnAvailableMeals = ref.watch(
      dailyPlanIsHideUnavailableStocksStateProvider,
    );
    final meals = ref.watch(dishStockProvider);
    final mealsList =
        isHideUnAvailableMeals
            ? meals
                .where((e) => isHideUnAvailableMeals && e.availablePortion > 0)
                .toList()
            : meals.toList();
    if (meals.isEmpty) {
      return const Center(child: Text('Нет добавленных блюд'));
    } else if (mealsList.isEmpty) {
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
        itemCount: mealsList.length,
        itemBuilder: (context, index) {
          final meal = mealsList[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(16),
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
