import 'package:flutter/material.dart';
import 'package:jm_audio_player/view/home_Page.dart';
import 'package:get/get.dart';
import 'controller/audio_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AudioController());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JM Audio Player',
      theme: ThemeData(
        textTheme: const TextTheme(
          titleSmall: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),
          titleMedium: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: Color.fromRGBO(44, 61, 122, 1),
              fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.normal),
          bodyLarge: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),
              fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.normal),
        ),
        primaryColor: const Color.fromRGBO(44, 61, 122, 1),
        primaryColorDark: Colors.black87,
        primaryColorLight: Colors.white70,
        secondaryHeaderColor: const Color.fromRGBO(255, 121, 118, 1),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
