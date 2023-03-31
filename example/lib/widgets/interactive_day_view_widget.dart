import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class InteractiveDayViewWidget extends StatelessWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  const InteractiveDayViewWidget({
    Key? key,
    this.state,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveDayView<Event>(
      key: state,
      width: width,
      onEventChanged: (event) {
        /// This is where I update the event in the database.
      },
      customHourLinePainter: _customHourLinePainter,
    );
  }

  CustomPainter _customHourLinePainter({
    required HourIndicatorSettings hourIndicatorSettings,
    required double minuteHeight,
    required bool showVerticalLine,
    required double verticalLineOffset,
  }) {
    return CustomHourLinePainter(
      lineColor: hourIndicatorSettings.color,
      lineHeight: hourIndicatorSettings.height,
      minuteHeight: minuteHeight,
      offset: hourIndicatorSettings.offset,
      showVerticalLine: showVerticalLine,
      verticalLineOffset: verticalLineOffset,
    );
  }
}

/// Paints 24 hour lines.
class CustomHourLinePainter extends CustomPainter {
  /// Color of hour line
  final Color lineColor;

  /// Height of hour line
  final double lineHeight;

  /// Offset of hour line from left.
  final double offset;

  /// Height occupied by one minute of time stamp.
  final double minuteHeight;

  /// Flag to display vertical line at left or not.
  final bool showVerticalLine;

  /// left offset of vertical line.
  final double verticalLineOffset;

  /// Paints 24 hour lines.
  CustomHourLinePainter({
    required this.lineColor,
    required this.lineHeight,
    required this.minuteHeight,
    required this.offset,
    required this.showVerticalLine,
    this.verticalLineOffset = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    // for (var i = 1; i < Constants.hoursADay; i++) {
    //   final dy = i * minuteHeight * 60;
    //   canvas.drawLine(Offset(offset, dy), Offset(size.width, dy), paint);
    // }

    // if (showVerticalLine)
    //   canvas.drawLine(Offset(offset + verticalLineOffset, 0),
    //       Offset(offset + verticalLineOffset, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CustomHourLinePainter &&
        (oldDelegate.lineColor != lineColor ||
            oldDelegate.offset != offset ||
            lineHeight != oldDelegate.lineHeight ||
            minuteHeight != oldDelegate.minuteHeight ||
            showVerticalLine != oldDelegate.showVerticalLine);
  }
}
