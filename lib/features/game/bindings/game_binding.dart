import 'package:get/get.dart';
import 'package:math_rush/features/game/controllers/game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameController());
  }
}
