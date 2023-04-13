import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class InteractiveWeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const InteractiveWeekViewWidget({Key? key, this.state, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      key: state,
      width: width,
      isInteractive: true,
    );
  }
}
