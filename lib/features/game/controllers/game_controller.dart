import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/game_config.dart';
import '../../../../data/models/question_model.dart';
import '../../home/controllers/home_controller.dart';
import '../logic/question_generator.dart';
import '../../../../core/services/ad_service.dart';

class GameController extends GetxController {
  final AdService _adService = Get.find<AdService>();

  final Rx<QuestionModel?> currentQuestion = Rx<QuestionModel?>(null);
  final RxDouble currentTimerValue = 1.0.obs;
  final RxInt score = 0.obs;
  final RxInt difficultyLevel = 1.obs;

  final RxBool isGameOver = false.obs;
  final RxBool isReviveCountDown = false.obs;
  final RxBool isWatchingAd = false.obs;
  final RxBool isNewHighScore = false.obs;
  final RxInt startCountdown = 0.obs;

  Timer? _rushTimer;
  double _currentMaxTime = GameConfig.baseTime;
  double _timeRemaining = GameConfig.baseTime;

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  void startGame() {
    score.value = 0;
    difficultyLevel.value = 1;
    isGameOver.value = false;
    isReviveCountDown.value = false;
    isWatchingAd.value = false;
    isNewHighScore.value = false;
    _currentMaxTime = GameConfig.baseTime;
    _adService.resetReviveStatus();
    _startCountdownThenRun(_generateRound);
  }

  void _startCountdownThenRun(VoidCallback onComplete) async {
    currentQuestion.value = null;
    for (int i = 3; i > 0; i--) {
      startCountdown.value = i;
      await Future.delayed(const Duration(seconds: 1));
      if (isGameOver.value) return; // Prevent if game exited early
    }
    startCountdown.value = 0;
    onComplete();
  }

  void resumeGameAfterRevive() {
    isReviveCountDown.value = false;
    _adService.markRevived();
    _startCountdownThenRun(_generateRound);
  }

  void _generateRound() {
    currentQuestion.value = QuestionGenerator.generate(difficultyLevel.value);
    _resetTimer();
  }

  void _resetTimer() {
    _rushTimer?.cancel();

    double decayAmount = score.value * GameConfig.timeDecayPerScore;
    _currentMaxTime = (GameConfig.baseTime - decayAmount).clamp(
      GameConfig.minTime,
      GameConfig.baseTime,
    );
    _timeRemaining = _currentMaxTime;
    currentTimerValue.value = 1.0;

    _rushTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isGameOver.value ||
          isReviveCountDown.value ||
          startCountdown.value > 0) {
        timer.cancel();
        return;
      }

      _timeRemaining -= 0.1;
      currentTimerValue.value = (_timeRemaining / _currentMaxTime).clamp(
        0.0,
        1.0,
      );

      if (_timeRemaining <= 0) {
        timer.cancel();
        _procGameOver();
      }
    });
  }

  void validateAnswer(bool selectedLeft) {
    if (isGameOver.value ||
        isReviveCountDown.value ||
        startCountdown.value > 0) {
      return;
    }

    final isCorrect = currentQuestion.value?.isLeftCorrect == selectedLeft;

    if (isCorrect) {
      score.value++;
      if (score.value % 5 == 0) {
        difficultyLevel.value++;
      }
      _generateRound();
    } else {
      _procGameOver();
    }
  }

  void _procGameOver() {
    _rushTimer?.cancel();

    if (!_adService.hasRevived) {
      isReviveCountDown.value = true;
    } else {
      _finalizeGameOver();
    }
  }

  void _finalizeGameOver() {
    isGameOver.value = true;

    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      if (score.value > homeCtrl.highScore.value) {
        isNewHighScore.value = true;
      }
      homeCtrl.updateHighScore(score.value);
    }

    _adService.showGameOverAd(onAdClosed: () {});
  }

  void watchReviveAd() {
    if (isWatchingAd.value) return;
    isWatchingAd.value = true;

    _adService.showReviveAd(
      onClosed: (rewardGranted) {
        isWatchingAd.value = false;
        if (rewardGranted) {
          resumeGameAfterRevive();
        } else {
          _finalizeGameOver();
        }
      },
    );
  }

  void skipRevive() {
    isReviveCountDown.value = false;
    _finalizeGameOver();
  }

  @override
  void onClose() {
    _rushTimer?.cancel();
    super.onClose();
  }
}
