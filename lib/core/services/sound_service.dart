import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final Map<String, AudioPlayer> _players = {
    _correct: AudioPlayer(playerId: 'sfx_correct'),
    _wrong: AudioPlayer(playerId: 'sfx_wrong'),
    _tap: AudioPlayer(playerId: 'sfx_tap'),
    _levelUp: AudioPlayer(playerId: 'sfx_level_up'),
    _gameOver: AudioPlayer(playerId: 'sfx_game_over'),
  };

  static const String _correct = 'audio/correct.mp3';
  static const String _wrong = 'audio/wrong.wav';
  static const String _tap = 'audio/tap.wav';
  static const String _levelUp = 'audio/level_up.wav';
  static const String _gameOver = 'audio/game_over.wav';

  static void playCorrect() {
    _play(_correct, volume: 0.9);
  }

  static void playWrong() {
    _play(_wrong, volume: 0.9);
  }

  static void playTap() {
    _play(_tap, volume: 0.55);
  }

  static void playLevelUp() {
    _play(_levelUp);
  }

  static void playCountdownTick() {
    _play(_tap, volume: 0.4);
  }

  static void playGameOver() {
    _play(_gameOver);
  }

  // BGM
  static void startBgm() {
    // TODO: Implement
  }

  static void stopBgm() {
    // TODO: Implement
  }

  static void stopAll() {
    for (final player in _players.values) {
      unawaited(player.stop());
    }
  }

  static void dispose() {
    for (final player in _players.values) {
      unawaited(player.dispose());
    }
  }

  static void _play(String assetPath, {double volume = 1.0}) {
    final player = _players[assetPath];
    if (player == null) return;

    unawaited(_restart(player, assetPath, volume));
  }

  static Future<void> _restart(
    AudioPlayer player,
    String assetPath,
    double volume,
  ) async {
    try {
      await player.stop();
      await player.play(
        AssetSource(assetPath),
        volume: volume,
        mode: PlayerMode.lowLatency,
      );
    } catch (_) {
      // Audio should not interrupt gameplay if playback fails on a device.
    }
  }
}
