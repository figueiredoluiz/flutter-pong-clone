import 'package:flutter/material.dart';

// PongPainter is a custom painter class that handles the rendering of the Pong game
class PongPainter extends CustomPainter {
  // Properties to store the current game state
  final double playerPaddleY;
  final double aiPaddleY;
  final double ballX;
  final double ballY;
  final int playerScore;
  final int aiScore;
  final double paddleHeight;
  final double ballSize;

  // Constructor to initialize the PongPainter with the current game state
  PongPainter({
    required this.playerPaddleY,
    required this.aiPaddleY,
    required this.ballX,
    required this.ballY,
    required this.playerScore,
    required this.aiScore,
    required this.paddleHeight,
    required this.ballSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object for drawing
    final paint = Paint()..color = Colors.white;

    // Draw top and bottom walls
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2), paint);
    canvas.drawRect(Rect.fromLTWH(0, size.height - 2, size.width, 2), paint);

    // Draw player paddle (left side)
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.05, size.height * (playerPaddleY + 1) / 2),
        width: size.width * 0.01,
        height: size.height * paddleHeight,
      ),
      paint,
    );

    // Draw AI paddle (right side)
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.95, size.height * (aiPaddleY + 1) / 2),
        width: size.width * 0.01,
        height: size.height * paddleHeight,
      ),
      paint,
    );

    // Draw ball (as a square)
    final ballSizePixels = size.width * ballSize;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * (ballX + 1) / 2, size.height * (ballY + 1) / 2),
        width: ballSizePixels,
        height: ballSizePixels,
      ),
      paint,
    );

    // Draw center line
    for (double i = 4; i < size.height - 4; i += size.height / 20) {
      canvas.drawRect(
        Rect.fromLTWH(size.width / 2 - 1, i, 2, size.height / 40),
        paint,
      );
    }

    // Draw the scores
    _drawScoreText(canvas, size, playerScore, true);
    _drawScoreText(canvas, size, aiScore, false);
  }

  // Helper method to draw the score text in a Pong-like style
  void _drawScoreText(Canvas canvas, Size size, int score, bool isPlayer) {
    final paint = Paint()..color = Colors.white;
    final cellSize = size.width * 0.03;
    final digitWidth = cellSize * 4; // 3 for the digit width + 1 for spacing
    final scoreString = score.toString();
    final totalWidth = digitWidth * scoreString.length;

    // Position the score on the left for the player, right for the AI
    double startX;
    if (isPlayer) {
      startX = size.width * 0.25 - totalWidth / 2;
    } else {
      startX = size.width * 0.75 - totalWidth / 2;
    }
    final startY = size.height * 0.1;

    // Draw each "pixel" of the score
    for (int i = 0; i < scoreString.length; i++) {
      final digitText = _getScoreText(scoreString[i]);
      for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 3; col++) {
          if (digitText[row * 3 + col] == '1') {
            canvas.drawRect(
              Rect.fromLTWH(
                startX + i * digitWidth + col * cellSize,
                startY + row * cellSize,
                cellSize,
                cellSize,
              ),
              paint,
            );
          }
        }
      }
    }
  }

  // Helper method to convert a digit to its Pong-style text representation
  String _getScoreText(String digit) {
    // Map each digit to its 3x5 pixel representation to emulate early arcades
    final digits = {
      '0': '111101101101111',
      '1': '010010010010010',
      '2': '111001111100111',
      '3': '111001111001111',
      '4': '101101111001001',
      '5': '111100111001111',
      '6': '111100111101111',
      '7': '111001001001001',
      '8': '111101111101111',
      '9': '111101111001111',
    };
    return digits[digit] ?? '';
  }

  @override
  // This method helps Flutter determine when to repaint this custom painter
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
