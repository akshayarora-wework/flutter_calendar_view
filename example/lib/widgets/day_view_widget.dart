import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class DayViewWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const DayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  State<DayViewWidget> createState() => _DayViewWidgetState();
}

class _DayViewWidgetState extends State<DayViewWidget> {
  @override
  Widget build(BuildContext context) {
    return DayView<Event>(
      key: widget.state,
      width: widget.width,
      isInteractive: true,
      onDateTap: (date) {
        CalendarControllerProvider.of<Event>(context).controller.add(
              CalendarEventData<Event>(
                title: 'title',
                date: date,
                startTime: date,
                endTime: date.add(Duration(hours: 1)),
                event: Event(title: 'event'),
                isActive: false,
              ),
            );
      },
    );
  }
}
