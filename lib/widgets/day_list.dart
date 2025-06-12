import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
// import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';
// import '../core/logger.dart';
// import '../utils/emoji_utils.dart';
// import 'package:my_recipe_app/providers/expandable_fab_interactor.dart';
// import 'package:my_recipe_app/screens/daily_plan/daily_plan_editor.dart';
import 'package:my_recipe_app/widgets/dish_list.dart';

class DayList extends ConsumerStatefulWidget {
  const DayList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DayListState();
}

class _DayListState extends ConsumerState<DayList> {
  final int range = 5;
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(2 * range + 1, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int todayIndex = range;
      final keyContext = _itemKeys[todayIndex].currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 400),
          alignment: 0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHideEmptyDays = ref.watch(dailyPlanIsHideEmptyDaysStateProvider);
    final isHideUnAvailableDishes = ref.watch(
      dishPlanIsHideUnavailableDishStateProvider,
    );
    final isHideUnAvailableDishesSwitch = ref.watch(
      dishPlanIsHideUnavailableDishSwitchStateProvider,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Скрыть недоступные блюда',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                isHideUnAvailableDishes ? 'Вкл' : 'Выкл',
                style: TextStyle(
                  fontSize: 16,
                  color: isHideUnAvailableDishes
                      ? Colors.green
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DishList(),
        ),
      ],
    );
  }
}

// class _DayCard extends ConsumerWidget {
//   final MealPlan mealPlan;
//
//   const _DayCard(this.mealPlan);
//
//   void _navigateToPlanEditor(DateTime date, BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => DailyPlanEditor(date: date)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     //TODO можно перенести в generateFromMealPlan()?
//     final mealMap = ref.watch(dishStockInteractorProvider).();
//     logger.d("_DayCard build $mealMap");
//     final mealList = _MealItem.generateFromMealPlan(
//       mealPlan.mealPortions,
//       mealMap,
//     );
//     logger.d("_DayCard mealList ${mealList}");
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               mealPlan.date.getDayWithDate(),
//               style: GoogleFonts.inter(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             IconButton(
//               onPressed: () => _navigateToPlanEditor(mealPlan.date, context),
//               icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade700),
//             ),
//           ],
//         ),
//         Divider(
//           color: Colors.grey.shade300,
//         ),
//         _MealList(items: mealList),
//       ],
//     );
//   }
// }
//
// class _MealList extends StatelessWidget {
//   final List<_MealItem> items;
//
//   const _MealList({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children:
//           items.map((meal) {
//             return Row(
//               children: [
//                 Text(
//                   getEmojiForMeal(meal.title),
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(meal.title, style: const TextStyle(fontSize: 18)),
//                 const SizedBox(width: 8),
//                 Text(
//                   "(порций: ${meal.portion})",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//     );
//   }
// }

// class _MealItem {
//   String title;
//   int portion;
//
//   _MealItem({required this.title, required this.portion});
//
//   static List<_MealItem> generateFromMealPlan(
//     Map<String, int> mealPortionMap,
//     Map<String, String> mealTitleMap,
//   ) =>
//       mealPortionMap.entries
//           .map(
//             (e) =>
//                 _MealItem(title: mealTitleMap[e.key] ?? "", portion: e.value),
//           )
//           .toList();
// }
