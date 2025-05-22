import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/models/meal_plan.dart';
import 'package:intl/intl.dart';
import 'package:my_recipe_app/screens/plan_editor.dart';

import '../providers/meal/meal_provider.dart';
import '../providers/meal_plan/meal_plan_notifier.dart';

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
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      itemCount: 2 * range + 1,
      itemBuilder: (context, index) {
        final offset = index - range;
        final date = today.add(Duration(days: offset));
        final mealPlan =
            mealPlans[date] ?? MealPlan(date: date, mealPortions: {});
        return Container(key: _itemKeys[index], child: _DayCard(mealPlan));
      },
    );
  }
}

class _DayCard extends ConsumerWidget {
  final MealPlan mealPlan;

  const _DayCard(this.mealPlan);

  void _navigateToPlanEditor(DateTime date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlanScreen(date: date)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO понимаю что это должно быть вынесено
    final mealMap = ref.watch(mealProvider.notifier).getMap();
    final mealList =
        mealPlan.mealPortions.entries
            .map(
              (e) => _MealItem(
                title: mealMap[e.key]?.title ?? "",
                portion: e.value,
              ),
            )
            .toList();

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  DateFormat('EEEE, d MMMM', 'ru').format(mealPlan.date),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed:
                      () => _navigateToPlanEditor(mealPlan.date, context),
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            SizedBox(height: 12),
            _MealList(items: mealList),
          ],
        ),
      ),
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
          items.map((e) {
            return Column(
              children: [
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.breakfast_dining, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(child: Text("${e.title} (порции: ${e.portion})")),
                  ],
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
}
