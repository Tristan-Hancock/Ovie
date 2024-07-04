import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ovie/main.dart';

void main() {
testWidgets('Show login page when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    // Verify that HomePage is displayed.
    expect(find.text('Home Page'), findsOneWidget);

    // Tap the 'Community' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.group));
    await tester.pumpAndSettle();
  expect(find.text('Sign In'), findsOneWidget);

    // Verify that CommunityPage is displayed.
    expect(find.text('Unread'), findsOneWidget);
  });
}
