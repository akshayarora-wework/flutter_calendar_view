// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../calendar_view.dart';

@immutable

/// {@macro calendar_event_data_doc}
class CalendarEventData<T extends Object?> {
  /// Specifies date on which all these events are.
  final DateTime date;

  /// Defines the start time of the event.
  /// [endTime] and [startTime] will defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView] or [WeekView]
  final DateTime? startTime;

  /// Defines the end time of the event.
  /// [endTime] and [startTime] defines time on same day.
  /// This is required when you are using [CalendarEventData] for [DayView]
  final DateTime? endTime;

  /// Title of the event.
  final String title;

  /// Description of the event.
  final String? description;

  /// Defines color of event.
  /// This color will be used in default widgets provided by plugin.
  final Color color;

  /// Event on [date].
  final T? event;

  final DateTime? _endDate;

  /// Define style of title.
  final TextStyle? titleStyle;

  /// Define style of description.
  final TextStyle? descriptionStyle;

  /// {@macro calendar_event_data_doc}
  CalendarEventData({
    required this.title,
    required DateTime date,
    this.description,
    this.event,
    this.color = Colors.blue,
    this.startTime,
    this.endTime,
    this.titleStyle,
    this.descriptionStyle,
    DateTime? endDate,
  })  : _endDate = endDate?.withoutTime,
        date = date.withoutTime;

  DateTime get endDate => _endDate ?? date;

  /// If this flag returns true that means event is occurring on multiple
  /// days and is not a full day event.
  ///
  bool get isRangingEvent {
    final diff = endDate.withoutTime.difference(date.withoutTime).inDays;

    return diff > 0 && !isFullDayEvent;
  }

  /// Returns if the events is full day event or not.
  ///
  /// If it returns true that means the events is full day. but also it can
  /// span across multiple days.
  ///
  bool get isFullDayEvent {
    return (startTime == null ||
        endTime == null ||
        (startTime!.isDayStart && endTime!.isDayStart));
  }

  Duration get duration {
    if (isFullDayEvent) return Duration(days: 1);

    final now = DateTime.now();

    final end = now.copyFromMinutes(endTime!.getTotalMinutes);
    final start = now.copyFromMinutes(startTime!.getTotalMinutes);

    if (end.isDayStart) {
      final difference =
          end.add(Duration(days: 1) - Duration(seconds: 1)).difference(start);

      return difference + Duration(seconds: 1);
    } else {
      return end.difference(start);
    }
  }

  /// Returns a boolean that defines whether current event is occurring on
  /// [currentDate] or not.
  ///
  bool occursOnDate(DateTime currentDate) {
    return currentDate == date ||
        currentDate == endDate ||
        (currentDate.isBefore(endDate.withoutTime) &&
            currentDate.isAfter(date.withoutTime));
  }

  /// Returns event data in [Map<String, dynamic>] format.
  ///
  Map<String, dynamic> toJson() => {
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "event": event,
        "title": title,
        "description": description,
        "endDate": endDate,
      };

  /// Returns new object of [CalendarEventData] with the updated values defined
  /// as the arguments.
  ///
  CalendarEventData<T> copyWith({
    String? title,
    String? description,
    T? event,
    Color? color,
    DateTime? startTime,
    DateTime? endTime,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    DateTime? endDate,
    DateTime? date,
  }) {
    return CalendarEventData(
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      description: description ?? this.description,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      endDate: endDate ?? this.endDate,
      event: event ?? this.event,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    return other is CalendarEventData<T> &&
        date.compareWithoutTime(other.date) &&
        endDate.compareWithoutTime(other.endDate) &&
        ((event == null && other.event == null) ||
            (event != null && other.event != null && event == other.event)) &&
        ((startTime == null && other.startTime == null) ||
            (startTime != null &&
                other.startTime != null &&
                startTime!.hasSameTimeAs(other.startTime!))) &&
        ((endTime == null && other.endTime == null) ||
            (endTime != null &&
                other.endTime != null &&
                endTime!.hasSameTimeAs(other.endTime!))) &&
        title == other.title &&
        color == other.color &&
        titleStyle == other.titleStyle &&
        descriptionStyle == other.descriptionStyle &&
        description == other.description;
  }

  @override
  int get hashCode => super.hashCode;

  /// Updates this eventData's startTime.
  CalendarEventData<T>? updateEventStartTime({
    required double primaryDelta,
    required double heightPerMinute,
    Duration minimumDuration = const Duration(minutes: 15),
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;

    // Calculate the new start time.
    var newStartTime = startTime!.add(deltaDuration);

    if (newStartTime.isAfter(endTime!.subtract(minimumDuration))) {
      // If the new start time is after the endTime - minimumDuration.
      newStartTime = endTime!.subtract(minimumDuration);
    } else if (newStartTime.isBefore(date.startOfToday)) {
      // If the new start time is before the start of this day then set it to
      // start of today.
      newStartTime = date.startOfToday;
    }

    return copyWith(
      startTime: newStartTime,
    );
  }

  /// Updates this event's endTime.
  CalendarEventData<T>? updateEventEndTime({
    required double primaryDelta,
    required double heightPerMinute,
    Duration minimumDuration = const Duration(minutes: 15),
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;

    // Calculate the new start time.
    var newEndTime = endTime!.add(deltaDuration);

    if (newEndTime.isBefore(startTime!.add(minimumDuration))) {
      // If the new end time is before the startTime + minimumDuration.
      newEndTime = endTime!.add(minimumDuration);
    } else if (newEndTime.isAfter(date.endOfToday)) {
      // If the new end time is after the end of this day then set it to end
      // of today.
      newEndTime = date.endOfToday;
    }

    return copyWith(
      endTime: newEndTime,
    );
  }

  /// Reschedule the event.
  CalendarEventData<T>? rescheduleEvent({
    required double primaryDelta,
    required double heightPerMinute,
  }) {
    assert(
      startTime != null,
      "To resize event, startTime can't be null",
    );
    assert(
      endTime != null,
      "To resize event, endTime can't be null",
    );

    // Calculate the change in duration.
    final deltaDuration = (primaryDelta / heightPerMinute).toDuration;
    // Calculate the new start time.
    final newStartTime = startTime!.add(deltaDuration);
    // Calculate the new end time.
    final newEndTime = endTime!.add(deltaDuration);

    if (newStartTime.isAfter(date.startOfToday) &&
        newEndTime.isBefore(date.endOfToday)) {
      // If the new start time is after the start of this day and before the end
      // of this day.
      return copyWith(
        startTime: newStartTime,
        endTime: newEndTime,
        date: newStartTime,
        endDate: newEndTime,
      );
    } else {
      return null;
    }
  }
}

/// {@template calendar_event_data_doc}
/// Stores all the events on [date].
///
/// If [startTime] and [endTime] both are 0 or either of them is null, then
/// event will be considered a full day event.
///
/// - [date] and [endDate] are used to define dates only. So, If you
/// are providing any time information with these two arguments,
/// it will be ignored.
///
/// - [startTime] and [endTime] are used to define the time span of the event.
/// So, If you are providing any day information (year, month, day), it will
/// be ignored. It will also, consider only hour and minutes as time. So,
/// seconds, milliseconds and microseconds will be ignored as well.
///
/// - [startTime] and [endTime] can not span more then one day. For example,
/// If start time is 11th Nov 11:30 PM and end time is 12th Nov 1:30 AM, it
/// will not be considered as valid time. Because for [startTime] and [endTime],
/// day will be ignored so, 11:30 PM ([startTime]) occurs after
/// 1:30 AM ([endTime]). Events with invalid time will throw
/// [AssertionError] in debug mode and will be ignored in release mode
/// in [DayView] and [WeekView].
/// {@endtemplate}
