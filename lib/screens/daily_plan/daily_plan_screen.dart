import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/daily_plan/daily_plan_view_interactor.dart';
import 'package:my_recipe_app/providers/expandable_fab_interactor.dart';
import 'package:my_recipe_app/screens/daily_plan/daily_plan_editor.dart';
import 'package:my_recipe_app/widgets/daily_plan_appbar.dart';
import 'package:my_recipe_app/widgets/dish_list.dart';
import 'package:my_recipe_app/widgets/day_list.dart';

class DailyPlanScreen extends ConsumerStatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  ConsumerState<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends ConsumerState<DailyPlanScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
      if (!_tabController.indexIsChanging) {
      Future.microtask(() {
        if (mounted) {
          ref.read(dailyPlanViewInteractorProvider).changeTabIndex(_tabController.index);
      }
    });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expandableFab = ref.watch(expandableFabInteractorProvider).getExpandableFab(context);
    
    return Scaffold(
      body: Column(
        children: [
          DailyPlanAppBar(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'План'),
              Tab(text: 'Запасы'),
            ],
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
              children: [
                DayList(),
                DishList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: expandableFab,
    );
  }
}
