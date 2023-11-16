import 'dart:developer';
import 'dart:ffi';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class AudioController extends GetxController{


  var audioFiles = <String>[].obs;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  var playingIndex = "".obs;
  late AudioPlayer _audioPlayer;
  var playingSongName = "".obs;
  List<SongModel>? songData;
  var playSong = "".obs;
  ProcessingState processingState = ProcessingState.idle;
  var totalDuration = const Duration().obs;
  var position = const Duration().obs;
  var isDragging = false.obs;
  var isPlaying = false.obs;
  var isPause = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _audioPlayer = AudioPlayer();
    // _getAudioFiles();
  }


  void playAudio(SongModel song) async {
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!),tag: MediaItem(
      id: '${song.id}',
      album: "${song.album}",
      title: song.displayNameWOExt,
      // artUri: Uri.parse('https://example.com/albumart.jpg'),
    )));
    _audioPlayer.play();
    playingSongName.value = song.title;
    isPlaying.value = true;
    isPause = false.obs;
    _audioPlayer.durationStream.listen((d) {
      totalDuration.value = d!;
    });
    _audioPlayer.positionStream.listen((d) {
      position.value = d;
    });
    _audioPlayer.playerStateStream.listen((event) {
      switch (event.processingState){
        case ProcessingState.completed:
          isPause.value = true;
          // processingState = ProcessingState.completed;
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
      }
    });
  }

  void resumeAudio(){
    log("Resume................!");
    isPause.value = false;
    _audioPlayer.play();
  }
  void pauseAudio(){
    log("paused................!");
    isPause.value = true;
    _audioPlayer.pause();
  }
  void stopAudio(){
    isPlaying.value = false;
    isPause.value = false;
    _audioPlayer.stop();
  }
  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  isSongComplete() {

  }



}