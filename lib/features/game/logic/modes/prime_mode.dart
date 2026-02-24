import 'dart:math';

import '../../../../core/utils/math_helper.dart';
import '../../../../data/models/question_model.dart';

class PrimeCheckMode {
  static QuestionModel generate(int difficulty) {
    final maxNum = 20 + (difficulty * 5);
    int num;
    if (Random().nextDouble() < 0.3) {
      List<int> primes = [];
      for (int i = 2; i <= maxNum; i++) {
        if (MathHelper.isPrime(i)) primes.add(i);
      }
      num = primes[Random().nextInt(primes.length)];
    } else {
      num = Random().nextInt(maxNum) + 1;
    }

    final isPrime = MathHelper.isPrime(num);
    final bool isLeftPrime = Random().nextBool();

    return QuestionModel(
      questionText: num.toString(),
      leftButtonText: isLeftPrime ? 'PRIME' : 'NOT',
      rightButtonText: isLeftPrime ? 'NOT' : 'PRIME',
      isLeftCorrect: isPrime == isLeftPrime,
    );
  }
}
