import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp_8_music_app/controllers/songs_controller.dart';
import 'package:tp_8_music_app/screens/home.dart';

void main() async {
  runApp(MyApp());
}

Future<void> _initDb() async {
  String path = await getDatabasesPath() + "favorite.db";
  Database db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute("CREATE TABLE FAVORITE (id )");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(SongController(), permanent: true);
      }),
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
