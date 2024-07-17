// Import necessary Flutter and Dart libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

// Import our custom PongPainter for rendering the game
import 'pong_painter.dart';

// PongGame is a StatefulWidget. This means it can change its state during the lifetime of the widget.
class PongGame extends StatefulWidget {
  // Constructor for PongGame
  const PongGame({super.key});

  @override
  // Create the mutable state for this widget
  State<PongGame> createState() => _PongGameState();
}

// The state class for PongGame. This is where all the game logic lives.
class _PongGameState extends State<PongGame> {
  // Constants for paddle height and ball size relative to the game area
  static const double _paddleHeight = 0.15;
  static const double _ballSize = 0.03;

  // Variables to track positions of paddles and ball
  late double _playerPaddleY;
  late double _aiPaddleY;
  late double _ballX;
  late double _ballY;

  // Variables to track ball speed
  late double _ballSpeedX;
  late double _ballSpeedY;

  // Variables to track scores
  int _playerScore = 0;
  int _aiScore = 0;

  // Timer for the game loop
  Timer? _gameLoop;

  // Variables for player paddle movement
  double _playerPaddleSpeed = 0;
  bool _isUpPressed = false;
  bool _isDownPressed = false;

  // AudioPlayer instances for game sounds
  late AudioPlayer _wallPlayer;
  late AudioPlayer _paddlePlayer;
  late AudioPlayer _pointPlayer;

  @override
  void initState() {
    super.initState();
    // Initialize the game
    _startNewRound();
    // Set up the game loop to update every 16 milliseconds (roughly 60 FPS)
    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (_) => _update());
    // Initialize audio players
    _initAudioPlayers();
  }

  // Initialize audio players
  void _initAudioPlayers() {
    _wallPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _paddlePlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _pointPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  // Methods to play sound effects
  void _playWallSound() {
    _wallPlayer.play(AssetSource('wall_sound.wav'));
  }

  void _playPaddleSound() {
    _paddlePlayer.play(AssetSource('paddle_sound.wav'));
  }

  void _playPointSound() {
    _pointPlayer.play(AssetSource('point_sound.wav'));
  }

  // Reset ball and paddle positions for a new round
  void _startNewRound() {
    _playerPaddleY = 0;
    _aiPaddleY = 0;
    _ballX = 0;
    _ballY = 0;
    _ballSpeedX = 0.01;
    _ballSpeedY = 0.01;
  }

  // Reset scores and start a new round
  void _resetScores() {
    setState(() {
      _playerScore = 0;
      _aiScore = 0;
      _startNewRound();
    });
  }

  // Main game update loop
  void _update() {
    setState(() {
      // Update ball position
      _ballX += _ballSpeedX;
      _ballY += _ballSpeedY;

      // Update player paddle position based on key presses
      if (_isUpPressed && _playerPaddleY > -1 + _paddleHeight / 2) {
        _playerPaddleSpeed = -0.03;
      } else if (_isDownPressed && _playerPaddleY < 1 - _paddleHeight / 2) {
        _playerPaddleSpeed = 0.03;
      } else {
        _playerPaddleSpeed *= 0.8; // Decelerate when no key is pressed
      }
      _playerPaddleY += _playerPaddleSpeed;
      _playerPaddleY = _playerPaddleY.clamp(-1 + _paddleHeight / 2, 1 - _paddleHeight / 2);

      // Ball collision with top and bottom walls
      if (_ballY <= -1 + _ballSize / 2 || _ballY >= 1 - _ballSize / 2) {
        _ballSpeedY = -_ballSpeedY;
        _playWallSound();
      }

      // Ball collision with player paddle
      if (_ballX <= -0.9 + _ballSize / 2 &&
          _ballY + _ballSize / 2 >= _playerPaddleY - _paddleHeight / 2 &&
          _ballY - _ballSize / 2 <= _playerPaddleY + _paddleHeight / 2) {
        _ballSpeedX = -_ballSpeedX;
        _ballSpeedX *= 1.1; // Increase speed slightly
        _ballSpeedY *= 1.1;
        _playPaddleSound();
      }

      // Ball collision with AI paddle
      if (_ballX >= 0.9 - _ballSize / 2 &&
          _ballY + _ballSize / 2 >= _aiPaddleY - _paddleHeight / 2 &&
          _ballY - _ballSize / 2 <= _aiPaddleY + _paddleHeight / 2) {
        _ballSpeedX = -_ballSpeedX;
        _ballSpeedX *= 1.1; // Increase speed slightly
        _ballSpeedY *= 1.1;
        _playPaddleSound();
      }

      // Scoring
      if (_ballX <= -1) {
        _aiScore++;
        _startNewRound();
        _playPointSound();
      }
      if (_ballX >= 1) {
        _playerScore++;
        _startNewRound();
        _playPointSound();
      }

      // Simple AI movement
      if (_aiPaddleY < _ballY && _aiPaddleY < 1 - _paddleHeight / 2) {
        _aiPaddleY += 0.02;
      } else if (_aiPaddleY > _ballY && _aiPaddleY > -1 + _paddleHeight / 2) {
        _aiPaddleY -= 0.02;
      }
    });
  }

  // Handle keyboard events
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() => _isUpPressed = true);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() => _isDownPressed = true);
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _resetScores();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() => _isUpPressed = false);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() => _isDownPressed = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              color: Colors.black,
              child: CustomPaint(
                painter: PongPainter(
                  playerPaddleY: _playerPaddleY,
                  aiPaddleY: _aiPaddleY,
                  ballX: _ballX,
                  ballY: _ballY,
                  playerScore: _playerScore,
                  aiScore: _aiScore,
                  paddleHeight: _paddleHeight,
                  ballSize: _ballSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources when the widget is removed
    _gameLoop?.cancel();
    _wallPlayer.dispose();
    _paddlePlayer.dispose();
    _pointPlayer.dispose();
    super.dispose();
  }
}