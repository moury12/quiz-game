import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';
import 'package:quiz_game/models/quiz_model.dart';
import 'package:quiz_game/views/home_page.dart';

class QuestionAnswerPage extends StatelessWidget {
  static const String routeName = '/quiz';

  const QuestionAnswerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => showDialog(builder: (context) => const AlertDialog
        (content: Text('You have to finish your exam'),
      ), context: context,),
      child: Scaffold(
        body: Obx(() {
          if (QuizController.to.questionList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            QuizModel currentQuestion = QuizController
                .to.questionList[QuizController.to.currentQuestionIndex.value];
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent)),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${QuizController.to.currentQuestionIndex.value + 1}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('/', style: TextStyle(fontSize: 16)),
                            ),
                            Text(
                              '${QuizController.to.questionList.length}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Score: ${QuizController.to.score.value}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        currentQuestion.score.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currentQuestion.question!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20,fontWeight:
                                FontWeight.w600),
                              ),
                            ),
                            if (currentQuestion.questionImageUrl != null)
                              Image.network(
                                currentQuestion.questionImageUrl!,
                                height: 200,
                                width: 200,
                                loadingBuilder:(context, child,
          loadingProgress) => const CircularProgressIndicator(),
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 200,
                                ),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      ..._buildAnswerButtons(currentQuestion),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  List<Widget> _buildAnswerButtons(QuizModel question) {
    List<String?> optionKeys = ['A', 'B', 'C', 'D'];
   if(!QuizController.to.answered.value) startTimerForNextQuestion();

    return optionKeys.map((optionKey) {
      String? optionText = _getOptionText(question.answers!, optionKey ?? '');
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: ElevatedButton(
          onPressed: QuizController.to.answered.value ||
              QuizController.to.gameOver.value
              ? null
              : () {

            QuizController.to.answerQuestion(optionKey ?? '');
            _cancelTimerIfQuizOver();

          },
          style: ButtonStyle(
            backgroundColor: QuizController.to.answered.value &&
                optionKey == question.correctAnswer
                ? MaterialStateProperty.all(Colors.green)
                : QuizController.to.answered.value &&
                optionKey == QuizController.to.wrongAnswer.value
                ? MaterialStateProperty.all(Colors.red)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Text(optionKey!),
                const Spacer(),
                Text(optionText ?? ' '),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
  void startTimerForNextQuestion() {
    QuizController.to.questionTimer = Timer(const Duration(seconds: 5), () {
      QuizController.to.nextQuestion();
    });
  }

  void _cancelTimerIfQuizOver() {
    if (QuizController.to.currentQuestionIndex.value ==
        QuizController.to.questionList.length - 1) {
      QuizController.to.questionTimer?.cancel();
    }
  }
  String? _getOptionText(Answers answers, String optionKey) {
    switch (optionKey) {
      case 'A':
        return answers.A;
      case 'B':
        return answers.B;
      case 'C':
        return answers.C;
      case 'D':
        return answers.D;
      default:
        return null;
    }
  }
}
