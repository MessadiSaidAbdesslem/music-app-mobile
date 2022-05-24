import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tp_8_music_app/controllers/songs_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static const route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SongController songController = Get.find<SongController>();

  @override
  void initState() {
    // TODO: implement initState
    Permission.storage.request().then((value) => print(value));
    songController.scanForMp3Files();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My cool music app')),
        body: Obx(
          () => songController.songs.value.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: songController.songs.value.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Material(
                        elevation: 2,
                        borderOnForeground: true,
                        borderRadius: BorderRadius.circular(5),
                        child: ListTile(
                          onTap: () async {
                            songController
                                .startSong(songController.songs[index]);
                            songController.currentIndex.value = index;
                          },
                          title: Text(songController.songs.value[index].title),
                          subtitle:
                              Text(songController.songs.value[index].artist),
                          leading: const Icon(Icons.music_note),
                        ),
                      ),
                    );
                  }),
        ));
  }
}
