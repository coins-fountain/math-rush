import 'dart:math';

import '../../../../data/models/question_model.dart';

class MathTrapMode {
  static QuestionModel generate(int difficulty) {
    final maxNum = 10 * difficulty;
    final num1 = Random().nextInt(maxNum) + 1;
    final num2 = Random().nextInt(maxNum) + 1;
    final isAddition = Random().nextBool();

    final int trueResult = isAddition ? num1 + num2 : num1 - num2;
    final bool isTrap = Random().nextBool();

    int displayedResult = trueResult;
    if (isTrap) {
      int offset = Random().nextBool() ? 10 : (Random().nextInt(2) + 1);
      offset = Random().nextBool() ? offset : -offset;
      displayedResult += offset;

      if (displayedResult == trueResult) displayedResult += 1;
    }

    final operator = isAddition ? '+' : '-';
    final questionStr = '$num1 $operator $num2 = $displayedResult';

    final bool isLeftTrue = Random().nextBool();

    return QuestionModel(
      questionText: questionStr,
      leftButtonText: isLeftTrue ? 'TRUE' : 'FALSE',
      rightButtonText: isLeftTrue ? 'FALSE' : 'TRUE',
      isLeftCorrect: !isTrap == isLeftTrue,
    );
  }
}
