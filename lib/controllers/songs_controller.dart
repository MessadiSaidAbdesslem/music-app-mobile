import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';
import 'package:tp_8_music_app/utils/database_helper.dart';

class SongController extends GetxController {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  RxList<SongInfo> songs = RxList<SongInfo>();
  final Rx<AudioManager> audioManager = AudioManager.instance.obs;
  RxBool isPlaying = false.obs;
  RxInt currentIndex = 0.obs;
  RxString currentSongTitle = "No song is Being played right now".obs;
  RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    print("on init");
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () async {
      print("shaked");
      await playOrPause();
    });

    DatabaseHelper.instance.querryAllRows().then((value) {
      favorites.value = value;
      favorites.refresh();
    });

    audioManager.value.onEvents((events, args) async {
      switch (events) {
        case AudioManagerEvents.ended:
          currentIndex.value = (currentIndex.value + 1) % songs.value.length;
          await startSong(songs.value[currentIndex.value]);
          break;
        case AudioManagerEvents.start:
          isPlaying.value = true;
          break;
        case AudioManagerEvents.next:
          currentIndex.value = (currentIndex.value + 1) % songs.value.length;
          await startSong(songs.value[currentIndex.value]);
          currentSongTitle.value = songs.value[currentIndex.value].displayName;
          break;
        case AudioManagerEvents.previous:
          if (currentIndex.value == 0)
            currentIndex.value = songs.value.length - 1;
          else
            currentIndex.value = (currentIndex.value - 1) % songs.value.length;
          await startSong(songs.value[currentIndex.value]);
          currentSongTitle.value = songs.value[currentIndex.value].displayName;
          break;
        default:
          break;
      }
    });

    detector.startListening();
    super.onInit();
  }

  Future<void> startSong(SongInfo song) async {
    currentSongTitle.value = song.displayName;
    await audioManager.value.start("file://" + song.filePath, song.title,
        desc: song.artist, cover: "assets/music.jpg");
  }

  Future<void> updateFavorites() async {
    favorites.value = await DatabaseHelper.instance.querryAllRows();
    favorites.refresh();
    print(favorites);
  }

  void stop() {
    isPlaying.value = false;
    audioManager.value.stop();
  }

  Future<void> playOrPause() async {
    if (audioManager.value.audioList.isEmpty) {
      startSong(songs.value[currentIndex.value]);
    } else {
      if (audioManager.value.isPlaying) {
        isPlaying.value = false;
        await audioManager.value.playOrPause();
      } else {
        isPlaying.value = true;
        await audioManager.value.playOrPause();
      }
    }
  }

  Future<void> playNext() async {
    isPlaying.value = true;
    currentIndex.value = (currentIndex.value + 1) % songs.value.length;
    await startSong(songs.value[currentIndex.value]);
    currentSongTitle.value = songs.value[currentIndex.value].displayName;
  }

  Future<void> playPrevious() async {
    isPlaying.value = true;
    if (currentIndex.value == 0)
      currentIndex.value = songs.value.length - 1;
    else
      currentIndex.value = (currentIndex.value - 1) % songs.value.length;
    await startSong(songs.value[currentIndex.value]);
    currentSongTitle.value = songs.value[currentIndex.value].displayName;
  }

  Future<void> scanForMp3Files() async {
    List<SongInfo> res = await audioQuery.getSongs();
    res.forEach((element) {
      songs.value.add(element);
    });
    songs.refresh();
  }

  Future<void> toggleCurrentSongFavorite(BuildContext context) async {
    bool songIsFavorite = (await DatabaseHelper.instance
                .songIsFavorite(songs.value[currentIndex.value]))
            .length >
        0;
    if (songIsFavorite) {
      await DatabaseHelper.instance
          .deleteSongFromFavorite(songs.value[currentIndex.value]);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Song removed from favorites"),
      ));
    } else {
      await DatabaseHelper.instance
          .insertSongToFavorite(songs.value[currentIndex.value]);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Song added to favorites"),
      ));
    }
  }
}
