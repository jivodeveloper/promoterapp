import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:promoterapp/screen/Dashboard.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/Common.dart';
import '../util/ApiHelper.dart';
import '../util/functionhelper.dart';
import 'Attendance.dart';
import 'LoginScreen.dart';
import 'dart:async';
import 'SalesReport.dart';
import 'package:permission_handler/permission_handler.dart' as Permissionhandler;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool isturnedon = false;
bool servicestatus = false;
bool haspermission = false;
late LocationPermission permission;
late Position position;

class HomeScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>{

  static const appTitle = 'Dashboard';
  int userid=0,beatId=0;
  int currentIndex = 0;

  @override
  void initState() {
    calllocationfunction();
    super.initState();
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

  void logout(BuildContext ctx) {

    showDialog(
      context: ctx,
      builder: (BuildContext context) =>
          AlertDialog(
            content: const Text('Logout'),
            actions: <TextButton>[

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () async {

                  SharedPreferences preferences = await SharedPreferences
                      .getInstance();
                  preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));


                },
                child: const Text('Yes'),
              )

            ],
          ),
      );

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        logout(context);
        return new Future(() => true);
      },
      child: Scaffold(

        appBar: AppBar(
          title: Text(appTitle),
        ),
        drawer: Drawer(
          child: ListView(
            children: [

              DrawerHeader(
                decoration: BoxDecoration(
                  color: app_theme,
                ),
                child: Container(
                    width: 128.0,
                    height: 128.0,


                    child: Center(
                      child: Image.asset(
                        'assets/Images/logo.png',height: 90,width: 90,
                      ),
                    )
                ),

              ),

              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              HomeScreen()
                      ));
                },
                leading: Image.asset(
                    'assets/Images/home.png', height: 25),
                title: Text(
                  'Home',
                  style: TextStyle(color: app_theme,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/attendance.png', height: 25),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              Attendance()));

                },
                title: Text(
                  'Attendance',
                  style: TextStyle(color:app_theme,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/report.png', height: 25),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              SalesReport()));


                },
                title: Text(
                  'Sales Report',
                  style: TextStyle(color: app_theme,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/logout.png', height: 25),
                onTap: () {
                  logout(context);
                },
                title: Text(
                  'Logout',
                  style: TextStyle(color: app_theme,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

            ],
          ),
        ),
        body: Dashboard(),

     )
    );

  }

  void showModal(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) =>

          AlertDialog(
            content: const Text('Example Dialog'),
            actions: <TextButton>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          ),
     );

  }

}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(minutes: 15), (timer) async {

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        checkGps();
      }
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": "device",
      },
    );

  });

}

Future<void> initializeService() async {

  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(

      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Jivo Dsr',
      initialNotificationContent: 'Jivo Dsr',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();

}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

checkGps() async {
  servicestatus = await Geolocator.isLocationServiceEnabled();
  if(servicestatus){
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }else if(permission == LocationPermission.deniedForever){
        print("'Location permissions are permanently denied");
      }else{
        haspermission = true;
      }
    }else{
      haspermission = true;
    }

    if(haspermission){

      getLocation();
    }
  }else{
    print("GPS Service is not enabled, turn on GPS location");
  }

}

getLocation() async {

  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  Battery _battery = Battery();
  var level = await _battery.batteryLevel;
  String? _currentAddress;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  await geocoding.placemarkFromCoordinates(position.latitude, position.longitude)
      .then((List<geocoding.Placemark> placemarks) {

    geocoding.Placemark place = placemarks[0];

    _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

    try{

      var locationentry=[{
        "personId":prefs.getInt(USER_ID),
        "timeStamp":getcurrentdatewithtime(),
        "latitude":position.latitude,
        "longitude":position.latitude,
        "battery":level,
        "GpsEnabled":isturnedon,
        "accuracy":position.accuracy,
        "speed":position.speed,
        "provider":"GPS",
        "altitude":position.altitude,
        "address":_currentAddress}];

      var request = json.encode(locationentry);
       print("Request data ${request.toString()}");
      savelocation(request);

    }catch(e){

      print("low eexception $e");

    }

  }).catchError((e) {

    print("eexception $e");

  });

}

