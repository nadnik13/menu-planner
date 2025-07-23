import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:food_planner/providers/core_providers.dart';
import 'package:food_planner/widgets/day_list.dart';
import '../../providers/daily_plan/providers.dart';
import '../../widgets/dish_list.dart';
import '../../widgets/daily_plan_appbar.dart';
import '../../utils/screen_utils.dart';

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
            .read(DailyPlanProviders.viewInteractor)
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
    // Адаптивные отступы для TabBarView  
    final tabPadding = ScreenUtils.adaptivePadding(
      context,
      small: const EdgeInsets.fromLTRB(12, 8, 12, 0),  // iPhone 12 mini - меньше отступы
      medium: const EdgeInsets.fromLTRB(16, 8, 16, 0), // iPhone 12/13/14 - стандартные
      large: const EdgeInsets.fromLTRB(20, 8, 20, 0),  // Pro Max - больше отступы
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false, // Позволяем AppBar растягиваться под status bar
        child: Column(
          children: [
            const DailyPlanAppBar(),
            Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF0F676E),
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: const Color(0xFF0F676E),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(text: 'План'),
                  Tab(text: 'Запасы'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: tabPadding,
                child: TabBarView(
                  controller: _tabController,
                  children: const [DayList(), MealList()],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ref.read(CoreProviders.expandableFabInteractor).getExpandableFab(
        type: 1, 
        context: context,
      ),
    );
  }
}
