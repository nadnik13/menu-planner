import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_provider.dart';
import 'package:my_recipe_app/utils/pluralize_utils.dart';

import '../providers/daily_plan/daily_plan_provider.dart';
import '../providers/daily_plan/daily_plan_view_interactor.dart';
import 'more_button.dart';

class DailyPlanAppBar extends ConsumerWidget {
  const DailyPlanAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cntPortion = ref.watch(availablePortionsCountProvider);
    final cntPlans = ref.watch(futurePlansCountProvider);
    final tabIndex = ref.watch(tabIndexProvider);
    //TODO: понять как это сделать более компактно и где
    String moreButtonText = '';
    if (tabIndex == 0) {
      moreButtonText =
          ref.watch(dailyPlanIsHideEmptyDaysStateProvider)
              ? 'Показать дни без плана'
              : 'Скрыть дни без плана';
    } else {
      moreButtonText =
          ref.watch(dailyPlanIsHideUnavailableStocksStateProvider)
              ? 'Показать все запасы'
              : 'Скрыть недоступные запасы';
    }
    String statisticText = '';
    if (tabIndex == 0) {
      statisticText = 'План на ${pluralizeDay(cntPlans)} вперед';
    } else {
      statisticText = 'Доступно ${pluralizePortion(cntPortion)} для плана';
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F676E), Color(0xB55AAE6D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 20, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 0.95,
                              ),
                              children: [
                                TextSpan(text: 'Дневник\n'),
                                TextSpan(text: 'питания'),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            statisticText,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MoreButton(
                      menuItems: [
                        PopupMenuItem<String>(
                          value: 'toggle_hide',
                          child: Text(moreButtonText),
                        ),
                      ],
                      onMenuSelected: (value) {
                        if (value == 'toggle_hide') {
                            ref
                                .watch(dailyPlanViewInteractorProvider)
                                .changeIsHideValue(tabIndex);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
