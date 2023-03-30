import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../extension.dart';
import '../model/event.dart';
import '../widgets/week_view_widget.dart';
import 'create_event_page.dart';

class InteractiveWeekViewDemo extends StatefulWidget {
  const InteractiveWeekViewDemo({Key? key}) : super(key: key);

  @override
  _InteractiveWeekViewDemoState createState() =>
      _InteractiveWeekViewDemoState();
}

class _InteractiveWeekViewDemoState extends State<InteractiveWeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: _addEvent,
      ),
      body: WeekViewWidget(),
    );
  }

  Future<void> _addEvent() async {
    final event =
        await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
      withDuration: true,
    ));
    if (event == null) return;
    CalendarControllerProvider.of<Event>(context).controller.add(event);
  }
}
