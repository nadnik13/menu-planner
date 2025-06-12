import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/models/daily_plan/daily_plan.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_interactor.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_editor.dart';
import '../core/logger.dart';
import '../providers/daily_plan/daily_plan_notifier.dart';
import '../utils/emoji_utils.dart';

class DayList extends ConsumerStatefulWidget {
  const DayList({super.key});

  @override
  ConsumerState<DayList> createState() => _DayListState();
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
    final today = DateTime.now().dateOnly;
    final mealPlans = ref.watch(daysPlanProvider);
    final isHideEmptyDays = ref.watch(dailyPlanIsHideEmptyDaysStateProvider);

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
          stops: const [0.0, 0.05, 0.95, 1.0], // регулируй зону "видимости"
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        physics:
            Theme.of(context).platform == TargetPlatform.iOS
                ? BouncingScrollPhysics()
                : ClampingScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: 2 * range + 1,
        itemBuilder: (context, index) {
          final offset = index - range;
          final date = today.add(Duration(days: offset));
          final mealPlanOrNull = mealPlans[date];
          if (isHideEmptyDays && (mealPlanOrNull == null)) {
            return SizedBox.shrink();
          }
          final mealPlan =
              mealPlanOrNull ?? DailyPlan(date: date, portions: {});
          return Container(key: _itemKeys[index],
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: _DayCard(mealPlan));
        },
      ),
    );
  }
}

class _DayCard extends ConsumerWidget {
  final DailyPlan mealPlan;

  const _DayCard(this.mealPlan);

  void _navigateToPlanEditor(DateTime date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanEditor(date: date)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO можно перенести в generateFromMealPlan()?
    final mealMap = ref.watch(dishStockInteractorProvider).getTitleMap();
    logger.d("_DayCard build $mealMap");
    final mealList = _MealItem.generateFromMealPlan(
      mealPlan.portions,
      mealMap,
    );
    logger.d("_DayCard mealList ${mealList}");

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealPlan.date.getDayWithDate(),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => _navigateToPlanEditor(mealPlan.date, context),
              icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade700),
            ),
          ],
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        _MealList(items: mealList),
      ],
    );
  }
}

class _MealList extends StatelessWidget {
  final List<_MealItem> items;

  const _MealList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          items.map((meal) {
            return Row(
              children: [
                Text(
                  getEmojiForMeal(meal.title),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(meal.title, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  "(порций: ${meal.portion})",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}

class _MealItem {
  String title;
  int portion;

  _MealItem({required this.title, required this.portion});

  static List<_MealItem> generateFromMealPlan(
    Map<String, int> mealPortionMap,
    Map<String, String> mealTitleMap,
  ) =>
      mealPortionMap.entries
          .map(
            (e) =>
                _MealItem(title: mealTitleMap[e.key] ?? "", portion: e.value),
          )
          .toList();
}
