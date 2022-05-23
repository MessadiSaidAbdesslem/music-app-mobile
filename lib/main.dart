import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp_8_music_app/controllers/songs_controller.dart';
import 'package:tp_8_music_app/screens/home.dart';
import 'package:tp_8_music_app/screens/main_navigator.dart';
import 'package:tp_8_music_app/utils/database_helper.dart';

import 'controllers/navigator_controller.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(SongController(), permanent: true);
        Get.put(MainNavigatorController(), permanent: true);
      }),
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      initialRoute: MainNavigator.route,
      getPages: [
        GetPage(name: MainNavigator.route, page: () => MainNavigator())
      ],
    );
  }
}
