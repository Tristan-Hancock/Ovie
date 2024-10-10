import 'package:flutter/material.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarDates extends StatefulWidget {
  final ObjectBox objectBox;

  CalendarDates({Key? key, required this.objectBox}) : super(key: key);

  @override
  _CalendarDatesState createState() => _CalendarDatesState();
}

class _CalendarDatesState extends State<CalendarDates> {
  late final CleanCalendarController calendarController;
  bool showButton = false;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    calendarController = CleanCalendarController(
      minDate: DateTime.now().subtract(Duration(days: 365)),
      maxDate: DateTime.now().add(Duration(days: 365)),
      initialFocusDate: DateTime.now(),
      weekdayStart: DateTime.monday,
      onRangeSelected: _onRangeSelected,
    );
    print('Calendar minDate: ${calendarController.minDate}');
  }

  void _onRangeSelected(DateTime start, DateTime? end) {
    print('Range selected: $start - $end');
    setState(() {
      startDate = start;
      endDate = end;
      showButton = true;
    });
  }

  Future<void> _savePeriodTracking() async {
    print('Attempting to save period tracking');
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in');
      return;
    }

    final userId = firebaseUser.uid;
    print('User ID: $userId');

    try {
      final user = widget.objectBox.userBox.query(User_.userId.equals(userId)).build().findFirst();
      
      if (user == null) {
        print('User not found in local database');
        return;
      }

      print('User found: ${user.userId}');

      final periodTracking = PeriodTracking(
        startDate: startDate!,
        endDate: endDate ?? startDate!,
      );
      periodTracking.user.target = user;

      print('PeriodTracking object created');

      if (widget.objectBox.periodTrackingBox == null) {
        print('Error: periodTrackingBox is null');
        // You might want to reinitialize ObjectBox here or show an error message
        return;
      }

      final id = widget.objectBox.periodTrackingBox.put(periodTracking);
      print('Saved PeriodTracking with ID: $id for date range: $startDate - ${endDate ?? startDate}');

      // Hide the button after saving
      setState(() {
        showButton = false;
      });
    } catch (e) {
      print('Error saving period tracking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631),
      body: Stack(
        children: [
          ScrollableCleanCalendar(
            calendarController: calendarController,
            layout: Layout.BEAUTY,
            calendarCrossAxisSpacing: 8.0,
            calendarMainAxisSpacing: 8.0,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            dayAspectRatio: 1.0,
            dayRadius: 20.0,
            daySelectedBackgroundColor: Color(0xFFFF7BAA),
            daySelectedBackgroundColorBetween: Color(0xFFBBBFFE),
            dayBackgroundColor: Color(0xFF101631),
            dayDisableBackgroundColor: Color(0xFF101631).withOpacity(0.4),
            dayTextStyle: TextStyle(color: Colors.white, fontSize: 16),
            weekdayTextStyle: TextStyle(color: Colors.white70, fontSize: 14),
            monthTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            showWeekdays: true,
            spaceBetweenMonthAndCalendar: 16.0,
          ),
          if (showButton)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _savePeriodTracking,
                child: Text('Track Cycle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF7BAA),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }
}