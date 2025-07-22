import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_recipe_app/providers/dish_stock/dish_stock_provider.dart';
import 'package:my_recipe_app/utils/pluralize_utils.dart';
import '../utils/screen_utils.dart';

import '../providers/daily_plan/daily_plan_provider.dart';
import '../providers/daily_plan/daily_plan_view_interactor.dart';
import 'more_button.dart';

class DailyPlanAppBar extends ConsumerWidget {
  const DailyPlanAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaTop = MediaQuery.of(context).padding.top;
    
    // Единая логика адаптации через ScreenUtils
    final titleFontSize = ScreenUtils.adaptiveFontSize(
      context,
      small: 32.0,   // iPhone 12 mini
      medium: 40.0,  // iPhone 12/13/14
      large: 44.0,   // Pro Max
    );
    
    final subtitleFontSize = ScreenUtils.adaptiveFontSize(
      context,
      small: 16.0,   // iPhone 12 mini
      medium: 20.0,  // iPhone 12/13/14
      large: 22.0,   // Pro Max
    );
    
    final horizontalPadding = ScreenUtils.adaptiveValue<double>(
      context,
      small: 20.0,   // iPhone 12 mini
      medium: 24.0,  // iPhone 12/13/14
      large: 28.0,   // Pro Max
    );
    
    final topPadding = safeAreaTop + (ScreenUtils.isSmallScreen(context) ? 16 : 20);
    
    final cntPortion = ref.watch(availablePortionsCountProvider);
    final cntPlans = ref.watch(futurePlansCountProvider);
    final tabIndex = ref.watch(tabIndexProvider);
    
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
      decoration: const BoxDecoration(
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
            padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, 20, 20),
            child: Row(
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
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 0.95,
                          ),
                          children: const [
                            TextSpan(text: 'Дневник\n'),
                            TextSpan(text: 'питания'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statisticText,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white.withOpacity(0.9),
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
          ),
        ],
      ),
    );
  }
}
