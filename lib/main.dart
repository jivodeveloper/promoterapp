import 'package:flutter/material.dart';
import 'package:promoterapp/screen/Splashscreen.dart';
import 'dart:async';
import 'package:promoterapp/util/Shared_pref.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefClass.init();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

}



