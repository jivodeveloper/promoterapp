import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/screen/Attendance.dart';
import 'package:promoterapp/screen/Dashboard.dart';
import 'dart:async';
import 'package:promoterapp/screen/SalesEntry.dart';
import 'package:promoterapp/screen/SalesReport.dart';
import 'package:promoterapp/util/Shared_pref.dart';

class HomeScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>{

  static const appTitle = 'Drawer Demo';
  int userid=0,beatId=0;
  int currentIndex = 0;

  @override
  void initState() {

    // Future.delayed(const Duration(seconds: 10), () {
    //   setState(() {
    //
    //    String val= SharedPrefClass.getString(ATT_STATUS);
    //
    //   });

    // });

    super.initState();
  }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

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

        child: Scaffold(
          body: [

            Dashboard(),
            Attendance(),
            SalesReport()

          ]
          [currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: app_theme,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            currentIndex: currentIndex,
            items: const [

              BottomNavigationBarItem(icon: Icon(Icons.home,color: app_theme), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person,color: app_theme), label: "Attendance"),
              BottomNavigationBarItem(icon: Icon(Icons.report,color: app_theme), label:"Reports"),

            ],
          ),

        ),
        onWillPop: () async {
          logout(context);
          return new Future(() => true);
        }

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

// Future<void> initializeService() async {
//
//   final service = FlutterBackgroundService();
//
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (Platform.isIOS || Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//
//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );
//
//   service.startService();
//
// }
//
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);
//
//   return true;
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//
//   DartPluginRegistrant.ensureInitialized();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   Timer.periodic(const Duration(minutes: 1), (timer) async {
//
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         checkGps();
//       }
//     }
//
//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": "device",
//       },
//     );
//
//   });
//
// }
//
// checkGps() async {
//   servicestatus = await Geolocator.isLocationServiceEnabled();
//   if(servicestatus){
//     permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied');
//       }else if(permission == LocationPermission.deniedForever){
//         print("'Location permissions are permanently denied");
//       }else{
//         haspermission = true;
//       }
//     }else{
//       haspermission = true;
//     }
//
//     if(haspermission){
//
//       getLocation();
//     }
//   }else{
//     print("GPS Service is not enabled, turn on GPS location");
//   }
//
// }
//
// getLocation() async {
//   position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//   Battery _battery = Battery();
//   var level = await _battery.batteryLevel;
//   String? _currentAddress;
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   await geocoding.placemarkFromCoordinates(position.latitude, position.longitude)
//       .then((List<geocoding.Placemark> placemarks) {
//
//     geocoding.Placemark place = placemarks[0];
//
//     _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
//     print("address${prefs.getInt(Common.USER_ID)}");
//
//     try{
//
//       var locationentry=[{
//         "personId":prefs.getInt(Common.USER_ID),
//         "timeStamp":getcurrentdatewithtime(),
//         "latitude":position.latitude,
//         "longitude":position.latitude,
//         "battery":level,
//         "GpsEnabled":isturnedon,
//         "accuracy":position.accuracy,
//         "speed":position.speed,
//         "provider":"GPS",
//         "altitude":position.altitude,
//         "address":_currentAddress}];
//
//
//       var request = json.encode(locationentry);
//
//       print("${request.toString()}");
//
//       savelocation(request);
//
//     }catch(e){
//
//       print("low eexception $e");
//
//     }
//
//   }).catchError((e) {
//
//     print("eexception $e");
//
//   });
//
// }
