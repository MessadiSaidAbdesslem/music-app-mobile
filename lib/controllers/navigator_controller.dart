import 'package:get/get.dart';

class MainNavigatorController extends GetxController {
  RxInt index = 0.obs;

  void updateIndex(int newIndex) {
    index.value = newIndex;
  }
}
