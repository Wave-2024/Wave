import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/HomeNavController/home_nav_controller.dart';
import 'package:wave/utils/constants/keys.dart';
import 'package:wave/view/screens/HomeNavigation/home_navigation_screen.dart';

void main() {
  group('HomeNavigationScreen Logic Test', () {
    testWidgets('Bottom navigation screen index update test',
        (WidgetTester tester) async {
      // Create a HomeNavController instance
      final homeNavController = HomeNavController();

      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: homeNavController,
          child:  MaterialApp(
            home: HomeNavigationScreen(),
          ),
        ),
      );

      // Verify that the initial screen index is 0
      expect(homeNavController.currentScreenIndex, equals(0));

      // Tap on the second bottom navigation bar item (index 1)
      await tester.tap(
          warnIfMissed: false, find.byKey(const Key(Keys.keyForSearchIcon)));
      await tester.pump();

      // Verify that the screen index is updated to 1
      expect(homeNavController.currentScreenIndex, equals(1));

      // Tap on the third bottom navigation bar item (index 2)
      await tester.tap(
          warnIfMissed: false, find.byKey(const Key(Keys.keyForAddPostIcon)));
      await tester.pump();

      // Verify that the screen index is updated to 2
      expect(homeNavController.currentScreenIndex, equals(2));
    });
  });
}
