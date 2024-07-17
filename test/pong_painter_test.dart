import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pong_clone/pong_painter.dart';

void main() {
  group('PongPainter', () {
    test('PongPainter initialization', () {
      final painter = PongPainter(
        playerPaddleY: 0,
        aiPaddleY: 0,
        ballX: 0,
        ballY: 0,
        playerScore: 0,
        aiScore: 0,
        paddleHeight: 0.15,
        ballSize: 0.03,
      );

      expect(painter.playerPaddleY, 0);
      expect(painter.aiPaddleY, 0);
      expect(painter.ballX, 0);
      expect(painter.ballY, 0);
      expect(painter.playerScore, 0);
      expect(painter.aiScore, 0);
      expect(painter.paddleHeight, 0.15);
      expect(painter.ballSize, 0.03);
    });

    test('PongPainter should paint without errors', () {
      final painter = PongPainter(
        playerPaddleY: 0,
        aiPaddleY: 0,
        ballX: 0,
        ballY: 0,
        playerScore: 0,
        aiScore: 0,
        paddleHeight: 0.15,
        ballSize: 0.03,
      );

      final mockCanvas = MockCanvas();
      const size = Size(800, 600);

      expect(() => painter.paint(mockCanvas, size), returnsNormally);
    });
  });
}

class MockCanvas implements Canvas {
  @override
  void drawRect(Rect rect, Paint paint) {}

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}