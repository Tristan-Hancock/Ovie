import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class Calendar extends StatefulWidget {
Calendar({Key? key}):super(key: key);


@override
State<Calendar> createState () => _CalendarState();


}

class _CalendarState extends State<Calendar> {

  DateTime? selectedFirst;
  DateTime? selectedSecond;

final calendarController =  CleanCalendarController(
  minDate: DateTime.now(),
  maxDate: DateTime.now().add(
    Duration(days: 365),
  ),
  weekdayStart: DateTime.sunday,
  
  );

  @override
 Widget build(BuildContext context) {
  return Scaffold(

    body: ScrollableCleanCalendar(
      
      calendarController: calendarController,
      layout: Layout.BEAUTY,
      calendarCrossAxisSpacing: 10,
      
      
      ),






  );
}}