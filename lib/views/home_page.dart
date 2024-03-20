import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';
import 'package:quiz_game/views/question_answer_page.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Get.toNamed(QuestionAnswerPage.routeName);
            }, child: const Text('start new game')),
            const SizedBox(height: 10,),

             Obx(
               () {
                 return Text(' high score of the best quiz round ${QuizController
                    .to.highScore.value??0}');
               }
             )
          ],
        ),
      ),
    );
  }
}
