class QuestionModel {
  final String questionText;
  final String leftButtonText;
  final String rightButtonText;
  final bool isLeftCorrect;

  QuestionModel({
    required this.questionText,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.isLeftCorrect,
  });
}
