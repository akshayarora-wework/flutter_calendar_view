import 'dart:math';

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../enumerations.dart';
import 'day_view_widget.dart';
import 'interactive_day_view_widget.dart';
import 'interactive_week_view_widget.dart';
import 'month_view_widget.dart';
import 'week_view_widget.dart';

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({Key? key, this.view = CalendarView.month})
      : super(key: key);

  final _breakPoint = 490.0;

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final width = min(_breakPoint, availableWidth);

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.grey,
      child: Center(
        child: _getView(view, width),
      ),
    );
  }

  Widget _getView(CalendarView view, double width) {
    switch (view) {
      case CalendarView.day:
        return DayViewWidget(
          width: width,
        );
      case CalendarView.week:
        return WeekViewWidget(
          width: width,
        );
      case CalendarView.month:
        return MonthViewWidget(
          width: width,
        );
      case CalendarView.interactiveDay:
        return InteractiveDayViewWidget(
          width: width,
        );
      case CalendarView.interactiveWeek:
        return InteractiveWeekViewWidget(
          width: width,
        );
    }
  }
}
