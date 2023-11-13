import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class AudioController extends GetxController{


  var audioFiles = <String>[].obs;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  late AudioPlayer audioPlayer;
  var playingIndex = "".obs;
  var audioPlayerState = PlayerState.STOPPED.obs;
  var playingSongName = "".obs;
  var playSong = "".obs;
  var totalDuration = const Duration().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    audioPlayer = AudioPlayer();
    // _getAudioFiles();
  }


  void playAudio(String path) async {
    int result = await audioPlayer.play(path, volume: 1.0, isLocal: true, stayAwake: true);
    log("Result $result");
    if(result == 1){
      audioPlayer.onDurationChanged.listen((Duration duration) {
        totalDuration.value = duration;
        log("duration $duration");
      });
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        audioPlayerState.value = state;
      });
    }

  }

  void resumeAudio(){
    audioPlayer.resume();
  }
  void pauseAudio(){
    audioPlayer.pause();
  }
  void stopAudio(){
    audioPlayer.stop();
  }
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }
  isSongComplete() {

  }



}