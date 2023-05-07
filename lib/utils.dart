import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class Entry {
  final String text;
  final myController = TextEditingController();

  Entry(this.text);

  @override
  String toString() => text;
}


/// Example entries.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEntry = LinkedHashMap<DateTime, List<Entry>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEntrySource);


//add journal entries from firebase here
final _kEntrySource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) :
    List.generate(
        item % 4 + 1, (index) => Entry('Entry $item | ${index + 1}')) }

  ..addAll({
    kToday: [
      Entry('Today\'s Event 1'),
      Entry('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month-3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);
