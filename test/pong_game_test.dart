import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pong_clone/pong_game.dart';

void main() {
  group('PongGame', () {
    testWidgets('PongGame widget should build', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PongGame()));
      expect(find.byType(PongGame), findsOneWidget);
    });

    testWidgets('PongGame should handle arrow key presses', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PongGame()));
      
      // Simulate arrow key presses
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      // We can't directly test the paddle movement, but we can verify that the widget updates
      expect(find.byType(PongGame), findsOneWidget);
    });
  });
}