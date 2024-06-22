import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ovie/main.dart';

void main() {
  testWidgets('Navigate to Community page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(showIntro: false)); // Pass showIntro: false to skip the intro screen

    // Verify that HomePage is displayed.
    expect(find.text('Home Page'), findsOneWidget);

    // Tap the 'Community' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.group));
    await tester.pumpAndSettle();

    // Verify that CommunityPage is displayed.
    expect(find.text('Unread'), findsOneWidget);
  });
}
