import 'package:get/get.dart';
import 'package:quiz_game/views/home_page.dart';
import 'package:quiz_game/views/question_answer_page.dart';

class AppRoutes{
static routes() => [
GetPage(name: HomeScreen.routeName, page:() => const HomeScreen()),
GetPage(name: QuestionAnswerPage.routeName, page:() => const QuestionAnswerPage()),
];
}