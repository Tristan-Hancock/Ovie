import 'package:flutter/material.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'period_prediction.dart'; // Import the PeriodPrediction class
import 'dailyreport.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser; // Alias Firebase's User class
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser; // Alias Firebase's User class
import 'package:ovie/services/models.dart'; // ObjectBox User class
import 'package:ovie/services/models.dart' as ObjectBoxModels; // Alias ObjectBox User class

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
  List<DateTime> predictedPeriods = []; // List to store predicted periods
  List<DailyLog> dailyLogs = []; // List to store fetched daily logs
  DailyReport? dailyReport; // Instance of DailyReport

 @override
  void initState() {
    super.initState();
    calendarController = CleanCalendarController(
      minDate: DateTime.now().subtract(Duration(days: 365)),
      maxDate: DateTime.now().add(Duration(days: 365)),
      initialFocusDate: DateTime.now(),
      weekdayStart: DateTime.monday,
      onRangeSelected: _onRangeSelected,
      onDayTapped: _onDayTapped,
    );
    dailyReport = DailyReport(objectBox: widget.objectBox);
    _loadSavedPeriodsAndLogs();
  }

  void _onDayTapped(DateTime date) {
    if (_isDateLogged(date)) {
      _showLogDetailsForDate(date);
    } else {
      // If it's not a logged date, we'll handle it as part of range selection
      _onRangeSelected(date, null);
    }
  }

  void _onRangeSelected(DateTime start, DateTime? end) {
    print('Range selected: $start - $end');
    setState(() {
      startDate = start;
      endDate = end;
      showButton = true;
    });
  }

  // Load saved periods and daily logs
 Future<void> _loadSavedPeriodsAndLogs() async {
    final firebaseUser = FirebaseAuthUser.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in');
      return;
    }

    final userId = firebaseUser.uid;
    print('Fetching saved periods and logs for user ID: $userId');

    // Ensure the user exists in the local ObjectBox database
    var user = widget.objectBox.userBox.query(User_.userId.equals(userId)).build().findFirst();
    if (user == null) {
      user = ObjectBoxModels.User(userId: userId); // ObjectBox User
      widget.objectBox.userBox.put(user);
      print('User added to local database: $userId');
    }

    savedPeriods = widget.objectBox.periodTrackingBox
        .query(PeriodTracking_.user.equals(user.id))
        .build()
        .find();

    predictedPeriods = PeriodPrediction(savedPeriods: savedPeriods).predictNextPeriods();

    dailyLogs = await dailyReport?.fetchLogsForCurrentUser() ?? [];

    setState(() {});
  }





  // Function to check if a date has a log entry
  bool _isDateLogged(DateTime date) {
    return dailyReport?.isDateLogged(date, dailyLogs) ?? false;
  }

  // Function to show log details when a date with a log is clicked
void _showLogDetailsForDate(DateTime date) {
  final log = dailyReport?.getLogForDate(date, dailyLogs);

  if (log != null) {
    // Retrieve the required data for the additional arguments
    final DateTime lastPeriodStartDate = savedPeriods.isNotEmpty
        ? savedPeriods.last.startDate
        : DateTime.now(); // Fallback if no period data exists
    final int cycleLength = 28; // Default or configurable cycle length
    final int periodDuration = 5; // Default or configurable period duration

    // Call the updated `showLogDetails` method with all arguments
    dailyReport?.showLogDetails(
      context,
      log,
      lastPeriodStartDate,
      cycleLength,
      periodDuration,
    );
  }
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

  // Function to check if a date is within the predicted period
  bool _isDateInPredictedPeriods(DateTime date) {
    for (var predicted in predictedPeriods) {
      if (date.isAtSameMomentAs(predicted) ||
          (date.isAfter(predicted.subtract(Duration(days: 1))) &&
              date.isBefore(predicted.add(Duration(days: 1))))) {
        return true;
      }
    }
    return false;
  }
Future<void> _savePeriodTracking() async {
    print('Attempting to save period tracking');
    final firebaseUser = FirebaseAuthUser.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in');
      return;
    }

    final userId = firebaseUser.uid;
    print('User ID: $userId');

    try {
      var user = widget.objectBox.userBox.query(User_.userId.equals(userId)).build().findFirst();
      if (user == null) {
        user = ObjectBoxModels.User(userId: userId); // ObjectBox User
        widget.objectBox.userBox.put(user);
        print('User added to local database: $userId');
      }

      final periodTracking = PeriodTracking(
        startDate: startDate!,
        endDate: endDate ?? startDate!,
      );
      periodTracking.user.target = user;

      final id = widget.objectBox.periodTrackingBox.put(periodTracking);
      print('Saved PeriodTracking with ID: $id for date range: $startDate - ${endDate ?? startDate}');

      setState(() {
        showButton = false;
        _loadSavedPeriodsAndLogs();
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
  bool isSaved = _isDateInSavedPeriods(dayValues.day);
  bool isLogged = _isDateLogged(dayValues.day);
  bool isPredicted = _isDateInPredictedPeriods(dayValues.day);
  bool isSelected = dayValues.isSelected;

return Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (dayValues.selectedMinDate == dayValues.day || dayValues.selectedMaxDate == dayValues.day)
                      ? Color(0xFFFF7BAA) // Start or end of the selected range
                      : Color(0xFFBBBFFE) // Middle of the selected range
                  : isSaved
                      ? Color(0xFFFF7BAA).withOpacity(0.5) // Highlight saved periods
                      : isPredicted
                          ? Color(0xFFBBBFFE).withOpacity(0.5) // Highlight predicted periods
                          : isLogged
                              ? Colors.lime // Highlight logged dates
                              : Colors.transparent, // No highlight
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${dayValues.day.day}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        },
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
