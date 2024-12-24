// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunar/calendar/Lunar.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../extensions.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile extends StatelessWidget {
  /// Title of the tile.
  final String title;

  /// Description of the tile.
  final String description;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int totalEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsetsGeometry padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsetsGeometry margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// Style for title
  final TextStyle? titleStyle;

  /// Style for description
  final TextStyle? descriptionStyle;

  /// This is default tile to display in day view.
  const RoundedEventTile({
    Key? key,
    required this.title,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.description = "",
    this.borderRadius = BorderRadius.zero,
    this.totalEvents = 1,
    this.backgroundColor = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadiusDirectional.only(
                topStart: borderRadius.topLeft,
                bottomStart: borderRadius.bottomLeft,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(.2),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: borderRadius.topRight,
                  bottomEnd: borderRadius.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title.isNotEmpty)
                    Expanded(
                      child: Text(
                        title,
                        style: titleStyle ??
                            const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: Color.fromRGBO(0x36, 0x65, 0x83, 1),
                              fontWeight: FontWeight.w600,
                            ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  if (description.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          description,
                          style: descriptionStyle ??
                              TextStyle(
                                fontSize: 17,
                                color: backgroundColor.accent.withAlpha(200),
                              ),
                        ),
                      ),
                    ),
                  if (totalEvents > 1)
                    Expanded(
                      child: Text(
                        "+${totalEvents - 1} more",
                        style: (descriptionStyle ??
                                TextStyle(
                                  color: backgroundColor.accent.withAlpha(200),
                                ))
                            .copyWith(fontSize: 17),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
          headerStyle: headerStyle,
        );
  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) {
    final lunarDate = Lunar.fromDate(date);
    return '${DateFormat('yyyy 年 M 月 d 日').format(date)} 周${lunarDate.getWeekInChinese()} ${lunarDate.getYearInGanZhiByLiChun()}年${lunarDate.getMonthInChinese()}月${lunarDate.getDayInChinese()}';
  }
}

class DefaultTimeLineMark extends StatelessWidget {
  /// Defines time to display
  final DateTime date;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Text style for time string.
  final TextStyle? markingStyle;

  /// Time marker for timeline used in week and day view.
  const DefaultTimeLineMark({
    Key? key,
    required this.date,
    this.markingStyle,
    this.timeStringBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeString = (timeStringBuilder != null)
        ? timeStringBuilder!(date)
        : DateFormat('HH:mm').format(date);

    return Transform.translate(
      offset: const Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0),
        child: Text(
          timeString,
          textAlign: TextAlign.right,
          style: markingStyle ??
              const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                height: 1.22,
              ),
        ),
      ),
    );
  }
}

/// This class is defined default view of full day event
class FullDayEventView<T> extends StatelessWidget {
  const FullDayEventView({
    Key? key,
    this.boxConstraints = const BoxConstraints(maxHeight: 100),
    required this.events,
    this.padding,
    this.itemView,
    this.titleStyle,
    this.onEventTap,
    required this.date,
  }) : super(key: key);

  /// Constraints for view
  final BoxConstraints boxConstraints;

  /// Define List of Event to display
  final List<CalendarEventData<T>> events;

  /// Define Padding of view
  final EdgeInsets? padding;

  /// Define custom Item view of Event.
  final Widget Function(CalendarEventData<T>? event)? itemView;

  /// Style for title
  final TextStyle? titleStyle;

  /// Called when user taps on event tile.
  final TileTapCallback<T>? onEventTap;

  /// Defines date for which events will be displayed.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: boxConstraints,
      child: ListView.builder(
        itemCount: events.length,
        padding: padding,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onEventTap?.call(events[index], date),
          child: itemView?.call(events[index]) ??
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(1.0),
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: events[index].color,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  events[index].title,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        color: events[index].color.accent,
                      ),
                  maxLines: 1,
                ),
              ),
        ),
      ),
    );
  }
}
