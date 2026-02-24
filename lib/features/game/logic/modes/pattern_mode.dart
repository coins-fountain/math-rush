import 'dart:math';

import '../../../../data/models/question_model.dart';

class PatternMode {
  static QuestionModel generate(int difficulty) {
    final startNum = Random().nextInt(10 * difficulty) + 1;
    final step = Random().nextInt(5 * difficulty) + 1;
    final isMissingInMiddle = Random().nextBool();

    int num1 = startNum;
    int num2 = startNum + step;
    int num3 = startNum + (step * 2);
    int num4 = startNum + (step * 3);

    int missingNumValue = isMissingInMiddle ? num3 : num4;

    int wrongNumValue = missingNumValue + (Random().nextBool() ? 1 : -1);

    String questionStr;
    if (isMissingInMiddle) {
      questionStr = '$num1, $num2, ?, $num4';
    } else {
      questionStr = '$num1, $num2, $num3, ?';
    }

    final bool isLeftCorrectBtn = Random().nextBool();

    return QuestionModel(
      questionText: questionStr,
      leftButtonText: isLeftCorrectBtn
          ? missingNumValue.toString()
          : wrongNumValue.toString(),
      rightButtonText: isLeftCorrectBtn
          ? wrongNumValue.toString()
          : missingNumValue.toString(),
      isLeftCorrect: isLeftCorrectBtn,
    );
  }
}
