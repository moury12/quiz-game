import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_game/bindings/initial_binding.dart';
import 'package:quiz_game/db/database_helper.dart';
import 'package:quiz_game/views/home_page.dart';

import 'routes/app_routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await DatabaseHelper.initDatabase();
  } catch (e) {
    debugPrint(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Game',
      theme: ThemeData.light(),
      getPages: AppRoutes.routes(),
      initialRoute: HomeScreen.routeName,
      initialBinding: InitialBinding(),
    );
  }
}
