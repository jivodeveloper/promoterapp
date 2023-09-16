import 'dart:async';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/screen/LoginScreen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/Shared_pref.dart';

class SplashScreen extends StatefulWidget{

  @override
  SplashScreenState createState() => new SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    checkisalreadyloggedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child:Image.asset('assets/Images/jivo_logo.png'),
                  )),
              CircularProgressIndicator()
            ],
          )
      ),
    );
  }

  void checkisalreadyloggedin() async{

    int userid;
    String personName;

    personName = SharedPrefClass.getString(PERSON_NAME);
    userid = SharedPrefClass.getInt(USER_ID);

    if(userid!=0 && userid!=null){

      Timer(Duration(seconds: 3), () =>Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => HomeScreen(),
      )));

    }else{

      Timer(Duration(seconds: 3), () =>Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => LoginScreen())));

    }

    //
    // Timer(const Duration(seconds:3),() {
    //
    //   Navigator.of(context).push(SwipeablePageRoute(
    //     builder: (BuildContext context) => LoginScreen(),
    //   ));
    //
    // });

  }


}
