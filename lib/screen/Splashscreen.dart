import 'dart:async';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/screen/LoginScreen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:permission_handler/permission_handler.dart' as Permissionhandler;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import '../util/Shared_pref.dart';

class SplashScreen extends StatefulWidget{

  @override
  SplashScreenState createState() => new SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  //AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

  void calllocationfunction() async{

    var locationstatus = await Permissionhandler.Permission.locationAlways.status;

    if(locationstatus.isGranted == false){

      Fluttertoast.showToast(
          msg: "Please allow location permission",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{
      await initializeService();
    }

  }

}

