import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:tp_8_music_app/models/song_model.dart';

class SongController extends GetxController {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  RxList<SongInfo> songs = RxList<SongInfo>();

  Future<void> scanForMp3Files() async {
    List<SongInfo> res = await audioQuery.getSongs();
    res.forEach((element) {
      songs.value.add(element);
    });
    songs.refresh();
  }
}
