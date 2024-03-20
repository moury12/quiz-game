import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_game/db/database_helper.dart';
import 'package:quiz_game/models/quiz_model.dart';
import 'package:quiz_game/services/quiz_service.dart';
import 'package:quiz_game/views/home_page.dart';

class QuizController extends GetxController {
  static QuizController get to => Get.find();
  RxList<QuizModel> questionList = <QuizModel>[].obs;
  RxInt currentQuestionIndex = 0.obs;
  Timer? questionTimer;
  RxInt score = 0.obs;
  Rx<bool> answered = false.obs;
  Rx<bool> gameOver = false.obs;
  RxString wrongAnswer = ''.obs;
  Rx<int?> highScore = 0.obs;
  RxInt durationInSeconds = 5.obs;
  Rx<double> progressValue = 1.0.obs;
  @override
  void onInit() {
    getQuestionAnswerData();
    getHighScore();
    super.onInit();
  }

  @override
  void onClose() {
    questionTimer?.cancel();
    super.onClose();
  }

  void getQuestionAnswerData() async {
    try {
      questionList.value = await QuizService.getQuestionAnswerData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getHighScore() async {
    highScore.value = await DatabaseHelper.getHighScore();
  }

  void startQuiz() {
    if (!answered.value) {
      answerQuestion('');
    }
    if (currentQuestionIndex.value < questionList.length - 1) {
      currentQuestionIndex.value++;
      answered.value = false;
      wrongAnswer.value = '';
    } else {
      gameOver.value = true;
      finishQuiz();
    }
  }

  void answerQuestion(String selectedAnswer) {
    if (!answered.value) {
      questionTimer?.cancel();
      _startTimerForNextQuestion();
      answered.value = true;
      if (selectedAnswer.isEmpty) {
        wrongAnswer.value =
            questionList[currentQuestionIndex.value].correctAnswer ?? '';
      } else if (questionList[currentQuestionIndex.value].correctAnswer ==
          selectedAnswer) {
        score.value += questionList[currentQuestionIndex.value].score!;
      } else {
        wrongAnswer.value = selectedAnswer;
      }
    }
  }

  void _startTimerForNextQuestion() {
    questionTimer?.cancel();
    questionTimer = Timer(const Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questionList.length - 1) {
      currentQuestionIndex.value++;
      answered.value = false;
      wrongAnswer.value = '';
    } else {
      gameOver.value = true;
/*
      questionTimer?.cancel();
*/
      showHighScoreDialog(score.value);
      finishQuiz();
    }
  }

  void finishQuiz() async {
    final currentScore = score.value;
    final highScore = await DatabaseHelper.getHighScore();
    if (highScore == null || currentScore > highScore) {
      await DatabaseHelper.updateHighScore(currentScore);
    }
  }

  void showHighScoreDialog(int currentScore) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Game Over',
      content: Column(
        children: [
          Text('Congratulations! Your score is: $currentScore'),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed(HomeScreen.routeName);
              resetState();
              getHighScore();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void resetState() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    answered.value = false;
    gameOver.value = false;
    wrongAnswer.value = '';
  }
}
