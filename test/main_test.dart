import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pong_clone/main.dart';
import 'package:flutter_pong_clone/pong_game.dart';

void main() {
  testWidgets('MyApp should render PongGame', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(PongGame), findsOneWidget);
  });
}