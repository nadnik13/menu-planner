import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/providers/expandable_fab_interactor.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
import 'package:my_recipe_app/widgets/day_list.dart';
import '../../widgets/dish_list.dart';
import '../../widgets/daily_plan_appbar.dart';

class DailyPlanScreen extends ConsumerStatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  ConsumerState<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends ConsumerState<DailyPlanScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(dailyPlanViewInteractorProvider)
            .changeTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  bool get isPlanTab => _tabController.index == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          DailyPlanAppBar(),
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'План'), Tab(text: 'Запасы')],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TabBarView(
                controller: _tabController,
                children: [DayList(), MealList()],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFabInteractor.getExpandableFab(type:1, context: context),
    );
  }
}
