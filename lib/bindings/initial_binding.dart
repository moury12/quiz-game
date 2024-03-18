import 'package:get/get.dart';
import 'package:quiz_game/controllers/quiz_controller.dart';
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QuizController>(
      QuizController(),
      permanent: true,
    );

  }
}