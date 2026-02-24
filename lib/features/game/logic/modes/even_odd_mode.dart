import 'dart:math';

import '../../../../core/utils/math_helper.dart';
import '../../../../data/models/question_model.dart';

class EvenOddMode {
  static QuestionModel generate(int difficulty) {
    final maxNum = difficulty * 10;
    final num = Random().nextInt(maxNum) + 1;
    final isEven = MathHelper.isEven(num);

    final bool isLeftEven = Random().nextBool();

    return QuestionModel(
      questionText: num.toString(),
      leftButtonText: isLeftEven ? 'EVEN' : 'ODD',
      rightButtonText: isLeftEven ? 'ODD' : 'EVEN',
      isLeftCorrect: isEven == isLeftEven,
    );
  }
}
