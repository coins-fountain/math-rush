import 'dart:math';
import '../../../../data/models/question_model.dart';

class ComparisonMode {
  static QuestionModel generate(int difficulty) {
    final maxNum = 20 * difficulty;
    int num1 = Random().nextInt(maxNum) + 1;
    int num2 = Random().nextInt(maxNum) + 1;

    while (num1 == num2) {
      num2 = Random().nextInt(maxNum) + 1;
    }

    final bool isLeftGreaterBtn = Random().nextBool();
    final bool isNum1Greater = num1 > num2;

    return QuestionModel(
      questionText: '$num1   ?   $num2',
      leftButtonText: isLeftGreaterBtn ? '>' : '<',
      rightButtonText: isLeftGreaterBtn ? '<' : '>',
      isLeftCorrect: isNum1Greater == isLeftGreaterBtn,
    );
  }
}
