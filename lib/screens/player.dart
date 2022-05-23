import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tp_8_music_app/controllers/songs_controller.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  SongController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            color: Colors.deepOrange,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FittedBox(
              child: Obx(() => Text(
                    controller.currentSongTitle.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          const Spacer(),
          Image.asset("assets/music.jpg"),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () async {
                  await controller.playPrevious();
                },
                icon: const Icon(Icons.fast_rewind),
                color: Theme.of(context).primaryColor,
              ),
              Obx(
                () => IconButton(
                  onPressed: () async {
                    await controller.playOrPause();
                  },
                  icon: Icon(controller.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.playNext();
                  setState(() {});
                },
                icon: const Icon(Icons.fast_forward),
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Obx(
                  () => IconButton(
                    onPressed: () async {
                      await controller.toggleCurrentSongFavorite();
                      await controller.updateFavorites();
                    },
                    icon: Icon(
                        controller.favorites.value.indexWhere((element) =>
                                    element['DISPLAYNAME'] ==
                                    controller
                                        .songs
                                        .value[controller.currentIndex.value]
                                        .displayName) !=
                                -1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red),
                  ),
                ),
                const Text("Add/Remove to favorite"),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
