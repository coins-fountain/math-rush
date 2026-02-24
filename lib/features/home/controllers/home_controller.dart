import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final RxInt highScore = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadHighScore();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore.value = prefs.getInt('high_score') ?? 0;
  }

  Future<void> updateHighScore(int newScore) async {
    if (newScore > highScore.value) {
      highScore.value = newScore;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', newScore);
    }
  }
}
