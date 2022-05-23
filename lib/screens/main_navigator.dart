import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tp_8_music_app/controllers/navigator_controller.dart';
import 'package:tp_8_music_app/screens/favorite.dart';
import 'package:tp_8_music_app/screens/home.dart';
import 'package:tp_8_music_app/screens/player.dart';

class MainNavigator extends GetView<MainNavigatorController> {
  MainNavigator({Key? key}) : super(key: key);
  static const route = "/mainNav";
  List<Widget> children = [HomePage(), PlayerScreen(), FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (index) {
              controller.updateIndex(index);
            },
            currentIndex: controller.index.value,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.play_arrow), label: "Player"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favorite"),
            ]),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.index.value,
          children: children,
        ),
      ),
    );
  }
}
