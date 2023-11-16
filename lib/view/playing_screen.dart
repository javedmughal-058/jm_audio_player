import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jm_audio_player/controller/audio_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingScreen extends StatelessWidget {
  final List<SongModel> songData;
  const PlayingScreen({super.key, required this.songData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AudioController audioController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.width * 0.3,
              width: size.width * 0.3,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle
                ),
              child: Obx(()=> audioController.isPause.value
                  ? const Icon(Icons.music_note_rounded, color: Colors.white,size: 56,)
                  : Lottie.asset('assets/audio/play1.json'))),
            const SizedBox(height: 30),
            Obx(()=> SizedBox(
              height: size.height * 0.07,
              width: size.width * 0.8,
              child: Text(songData[int.parse(audioController.playingIndex.value)].title,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            )),
            const SizedBox(height: 10),
            Obx(()=> Text(songData[int.parse(audioController.playingIndex.value)].artist == "<unknown>"
                ? "Unknown Artist"
                : songData[int.parse(audioController.playingIndex.value)].artist.toString(),
                  textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall)),
            SizedBox(height: size.height * 0.3),
            Obx(()=> Row(
              children: [
                Text(audioController.formatDuration(audioController.position.value),
                    style: Theme.of(context).textTheme.titleSmall),
                Expanded(
                  child: Slider(
                    value: audioController.position.value.inSeconds.toDouble(),
                    min: 0,
                    max: audioController.totalDuration.value.inSeconds.toDouble(),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).secondaryHeaderColor,
                    onChanged: (double value) {
                      audioController.seekToSecond(value.toInt());
                      value = value;
                    },
                    onChangeEnd: (double value) {
                      audioController.isDragging.value = false;
                    },
                    onChangeStart: (double value) {
                      audioController.isDragging.value = true;
                    },
                  ),
                ),
                Text(audioController.formatDuration(audioController.totalDuration.value),
                    style: Theme.of(context).textTheme.titleSmall)
              ],
            )),
            Obx(()=> Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  if(audioController.playingIndex.value != "0"){
                    var previousSongIndex = int.parse(audioController.playingIndex.value) - 1;
                    audioController.playingIndex.value = previousSongIndex.toString();
                    audioController.playAudio(songData[previousSongIndex]);
                  }
                  else{
                    log("first Song");
                  }
                }, icon: const Icon(Icons.skip_previous, size: 40)),
                IconButton(
                    onPressed: (){
                      if(!audioController.isPause.value){
                        audioController.pauseAudio();
                      }
                      else{
                        audioController.isPlaying.value = true;
                        audioController.resumeAudio();
                      }
                    },
                    icon: Icon(audioController.isPause.value
                        ? Icons.play_arrow_outlined : Icons.pause, size: 40)),
                IconButton(onPressed: (){
                    if(audioController.playingIndex.value != "${songData.length-1}"){
                      var nextSongIndex = int.parse(audioController.playingIndex.value) + 1;
                      audioController.playingIndex.value = nextSongIndex.toString();
                      audioController.playAudio(songData[nextSongIndex]);
                    }
                    else{
                      log("last Song");
                    }
                  }, icon: const Icon(Icons.skip_next, size: 40))
              ],
            )),
          ],
        ),
      ),
    );
  }
}
