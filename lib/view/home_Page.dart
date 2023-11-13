import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jm_audio_player/controller/audio_controller.dart';
import 'package:jm_audio_player/utils/helper.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;
  final AudioController audioController = Get.find();

  @override
  void initState() {
    super.initState();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();

  }
  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("JM Audio Player", style: Theme.of(context).textTheme.bodyLarge),
        elevation: 2,
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
              // Default values:
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {

                if (item.hasError) {
                  return Text(item.error.toString());
                }

                if (item.data == null) {
                  return const CircularProgressIndicator();
                }

                if (item.data!.isEmpty) return const Text("Nothing found!");

                return Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    ListView.builder(
                      itemCount: item.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 25),
                          onTap: (){

                            if(audioController.audioPlayerState.value == PlayerState.PLAYING && audioController.playingIndex.value == index.toString()){
                              audioController.stopAudio();
                            }
                            else{
                              audioController.audioPlayerState.value = PlayerState.PLAYING;
                              audioController.playingIndex.value = index.toString();
                              audioController.playingSongName.value = item.data![index].title;
                              audioController.playAudio(item.data![index].data);
                            }
                          },
                          title: Text(item.data![index].title, style: Theme.of(context).textTheme.bodyMedium),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.data![index].artist ?? "No Artist", style: Theme.of(context).textTheme.bodySmall),
                              // Text(item.data![index].duration.toString(), style: Theme.of(context).textTheme.bodySmall),
                              // Text(Helper.convertToTime(duration: item.data![index].duration!), style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          trailing: Obx(()=> audioController.playingIndex.value == index.toString() &&  audioController.audioPlayerState.value == PlayerState.PLAYING
                              ? const Icon(Icons.pause, color: Colors.white)
                              : const Icon(Icons.play_arrow, color: Colors.white)),
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.music_note_outlined, color: Colors.white),
                          ),
                        );
                      },
                    ),
                    Obx(()=> audioController.audioPlayerState.value == PlayerState.PLAYING
                        || audioController.audioPlayerState.value == PlayerState.PAUSED
                        || audioController.audioPlayerState.value == PlayerState.COMPLETED
                        ? Positioned(
                          bottom: 0,
                          right: 20,
                          left: 20,
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        if(audioController.audioPlayerState.value == PlayerState.PLAYING){
                                          audioController.audioPlayerState.value = PlayerState.PAUSED;
                                          audioController.pauseAudio();
                                        }
                                        else{
                                          audioController.audioPlayerState.value = PlayerState.PLAYING;
                                          audioController.resumeAudio();
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                          ),
                                          child: Icon(audioController.audioPlayerState.value == PlayerState.PLAYING
                                              ? Icons.pause : Icons.play_arrow_outlined, color: Theme.of(context).primaryColor)),
                                    ),
                                    Obx(()=> SizedBox(
                                      width: 150,
                                      child: Text(audioController.playingSongName.value, maxLines: 1,overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall),
                                    )),
                                  ],
                                ),
                                audioController.audioPlayerState.value == PlayerState.PAUSED || audioController.audioPlayerState.value == PlayerState.COMPLETED
                                    ? GestureDetector(
                                      onTap: (){
                                        audioController.audioPlayerState.value = PlayerState.STOPPED;
                                      },
                                      child: const Icon(Icons.highlight_remove, color: Colors.white, size: 28),
                                    )
                                    : Lottie.asset('assets/audio/play1.json', width: 40)

                              ],
                            ),
                          ),
                        )
                        : const SizedBox()),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.shade500,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}