import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_view_interactor.dart';

import '../models/meal.dart';
import '../providers/meal/meal_provider.dart';
import '../providers/meal/meal_remove_interactor.dart';
import '../screens/statusDropButton.dart';
import '../utils/emoji_utils.dart';

class MealList extends ConsumerStatefulWidget {
  const MealList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MealListState();
}

class _MealListState extends ConsumerState<MealList> {
  @override
  Widget build(BuildContext context) {
    final isHideUnAvailableMeals = ref.watch(
      mealPlanIsHideUnavailableMealStateProvider,
    );
    final meals = ref.watch(mealProvider);
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
          margin: const EdgeInsets.symmetric( vertical: 4),
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
          child: _MealCard(meal)
        );
      },
    ));
  }
}

class _MealCard extends ConsumerWidget {
  final Meal meal;
  const _MealCard(this.meal);

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
              onPressed: () => ref.read(mealRemoveInteractorProvider).removeMeal(meal),
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
