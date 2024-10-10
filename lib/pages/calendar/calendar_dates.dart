import 'package:flutter/material.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';

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
  List<PeriodTracking> savedPeriods = []; // List to store saved periods

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

    _loadSavedPeriods(); // Load previously saved periods
    print('Calendar minDate: ${calendarController.minDate}');
  }

  // Load saved periods from ObjectBox
  Future<void> _loadSavedPeriods() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in');
      return;
    }

    final userId = firebaseUser.uid;
    print('Fetching saved periods for user ID: $userId');

    // Query the saved periods for the current user
    final user = widget.objectBox.userBox.query(User_.userId.equals(userId)).build().findFirst();
    if (user != null) {
      savedPeriods = widget.objectBox.periodTrackingBox
          .query(PeriodTracking_.user.equals(user.id))
          .build()
          .find();

      print('Loaded ${savedPeriods.length} saved periods');

      // Update the calendar with the saved periods
      setState(() {});
    } else {
      print('User not found');
    }
  }

  // Function to update the selected range when the user selects dates
  void _onRangeSelected(DateTime start, DateTime? end) {
    print('Range selected: $start - $end');
    setState(() {
      startDate = start;
      endDate = end;
      showButton = true;
    });
  }

  // Function to check if a date is within any saved period
  bool _isDateInSavedPeriods(DateTime date) {
    for (var period in savedPeriods) {
      if (date.isAfter(period.startDate.subtract(Duration(days: 1))) &&
          date.isBefore(period.endDate.add(Duration(days: 1)))) {
        return true;
      }
    }
    return false;
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

      final id = widget.objectBox.periodTrackingBox.put(periodTracking);
      print('Saved PeriodTracking with ID: $id for date range: $startDate - ${endDate ?? startDate}');

      // Hide the button after saving
      setState(() {
        showButton = false;
        _loadSavedPeriods(); // Reload saved periods to update the calendar
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
     dayBuilder: (context, dayValues) {
  bool isSaved = _isDateInSavedPeriods(dayValues.day); // Check if the date is in saved periods
  bool isSelected = dayValues.isSelected; // Check if the date is part of the currently selected range

  return Container(
    decoration: BoxDecoration(
      color: isSelected
          ? (dayValues.selectedMinDate == dayValues.day || dayValues.selectedMaxDate == dayValues.day)
              ? Color(0xFFFF7BAA) // Start or end of the selected range
              : Color(0xFFBBBFFE) // Middle of the selected range
          : isSaved
              ? Color(0xFFFF7BAA).withOpacity(0.5) // Highlight saved periods
              : Colors.transparent, // No highlight
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(
      '${dayValues.day.day}', // Display the day
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}


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
