import 'package:flutter/material.dart';
import 'package:promoterapp/provider/DropdownProvider.dart';
import 'package:promoterapp/screen/Splashscreen.dart';
import 'dart:async';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefClass.init();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[

        ChangeNotifierProvider<DropdownProvider>(
            create: (_)=> DropdownProvider()
        ),

        // ChangeNotifierProvider<PromoterStockProvider>(
        //     create: (_)=> PromoterStockProvider()
        // ),

      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );

  }

}



