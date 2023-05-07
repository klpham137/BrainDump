import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'EntryView.dart';
import 'JournalEntry.dart';
import 'JournalDrawer.dart';
import '../utils.dart';


class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Stream<List<Entry>> readEntries() => FirebaseFirestore.instance
      .collection('journal_entries')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs .map((doc) => Entry.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BrainDump'),
      ),
      drawer:
      const JournalDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 30, bottom: 20, left: 12),
            child: const Text(
              'My Journal',
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TableCalendar(
              daysOfWeekHeight: 100,
              rowHeight: 60,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {

                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    final date = '${selectedDay.day}-${selectedDay.month}-${selectedDay.year}';

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryView(date: date),
                        )
                    );
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 30, top: 125),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          const JournalEntry()),
                    );
                  },
                  focusColor: Colors.blueGrey,
                  child: const Icon(Icons.add_circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Entry {
  final String date;
  final String body;
  String id;

  Entry({
    this.id = '',
    required this.date,
    required this.body,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'body': body,
        'date': date,
      };

  static Entry fromJson(Map<String, dynamic> json) =>
      Entry(
        id: json['id'],
        body: json['body'],
        date: json['date'],
      );
}