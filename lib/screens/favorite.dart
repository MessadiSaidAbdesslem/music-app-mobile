import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp_8_music_app/controllers/songs_controller.dart';
import 'package:tp_8_music_app/utils/database_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  SongController controller = Get.find<SongController>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Obx(
        () => controller.favorites.value.isEmpty
            ? const Center(
                child: Text("You have no songs in your favorites yet"),
              )
            : ListView.builder(
                itemCount: controller.favorites.value.length,
                itemBuilder: (context, _) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: ListTile(
                        onTap: () async {
                          await controller.startSong(controller.songs.value
                              .firstWhere((element) =>
                                  element.displayName ==
                                  controller.favorites.value[_]
                                      ['DISPLAYNAME']));
                        },
                        title: Text(
                          controller.favorites.value[_]['DISPLAYNAME'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(controller.favorites.value[_]['ARTIST']),
                        leading: IconButton(
                          onPressed: () async {
                            Database? db =
                                await DatabaseHelper.instance.database;
                            await db!.delete("FAVORITE",
                                where: "DISPLAYNAME = ?",
                                whereArgs: [
                                  controller.favorites.value[_]['DISPLAYNAME']
                                ]);
                            await controller.updateFavorites();
                          },
                          icon: const Icon(Icons.favorite,
                              color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
