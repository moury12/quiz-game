import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quiz_game/models/quiz_model.dart';
import 'package:quiz_game/services/quiz_service.dart';

class QuizController extends GetxController{
  static QuizController get to => Get.find();
  RxList<QuizModel> questionList = <QuizModel>[].obs;
  RxInt currentQuestionIndex = 0.obs;
  Timer? _timer;
  RxInt score = 0.obs;
  Rx<bool> answered = false.obs;
  Rx<bool> gameOver = false.obs;
  RxString wrongAnswer =''.obs;
  @override
  void onInit() {
    getQuestionAnswerData();
    super.onInit();
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  void getQuestionAnswerData() async{
    try {
      questionList.value = await QuizService.getQuestionAnswerData();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  void startQuiz() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentQuestionIndex.value < questionList.length) {
        _timer!.cancel();
      } else {
        currentQuestionIndex.value++;
      }
    });
  }
  void answerQuestion(String selectedAnswer) {
    if (!answered.value) {
      answered.value = true;
      if (questionList[currentQuestionIndex.value].correctAnswer ==
      selectedAnswer) {
        score.value += questionList[currentQuestionIndex.value].score!;
      }
      if (questionList[currentQuestionIndex.value].correctAnswer != selectedAnswer) {
        wrongAnswer.value = selectedAnswer; // Store the selected wrong answer
      }
    }
  }
  void nextQuestion() {
    if (currentQuestionIndex.value < questionList.length - 1) {
      currentQuestionIndex.value++;
      answered.value = false;
    } else {
      gameOver.value = true;
    }
  }
}