import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class CalendarDates extends StatefulWidget {

  CalendarDates({Key? key}) : super(key: key);
  @override
  _CalendarDatesState createState() => _CalendarDatesState();
}

class _CalendarDatesState extends State<CalendarDates> {
  final calendarController = CleanCalendarController(
    minDate: DateTime.now().subtract(Duration(days: 365)), // One year ago
    maxDate: DateTime.now().add(Duration(days: 365)), // One year in the future
    initialFocusDate: DateTime.now(), // Focus on the current date
    weekdayStart: DateTime.monday, // Start the calendar on Monday
    
    onRangeSelected: (minDate, maxDate) {
      print('Selected range: $minDate - $maxDate');
    },
  );

  @override
  void initState() {
    super.initState();
    // Debug to check the min date setup
    print('Calendar minDate: ${calendarController.minDate}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Dark background color
      body: ScrollableCleanCalendar(
        calendarController: calendarController,
        layout: Layout.BEAUTY, // Use the BEAUTY layout
        calendarCrossAxisSpacing: 8.0, // Horizontal spacing between days
        calendarMainAxisSpacing: 8.0, // Vertical spacing between days
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32), // Padding around the calendar
        dayAspectRatio: 1.0, // Aspect ratio for day items
        dayRadius: 20.0, // Circular day items
        daySelectedBackgroundColor: Color(0xFFFF7BAA), // Color for selected day
        daySelectedBackgroundColorBetween: Color(0xFFBBBFFE), // Highlight for dates between range
        dayBackgroundColor: Color(0xFF101631), // Background color for unselected days
        dayDisableBackgroundColor: Color(0xFF101631).withOpacity(0.4), // Disabled days background
        dayTextStyle: TextStyle(color: Colors.white, fontSize: 16), // Custom day text style
        weekdayTextStyle: TextStyle(color: Colors.white70, fontSize: 14), // Custom weekday text
        monthTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // Custom month text
        showWeekdays: true, // Show weekdays
        spaceBetweenMonthAndCalendar: 16.0, // Spacing between month name and calendar grid
      ),
    );
  }
}
