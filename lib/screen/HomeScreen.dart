import 'package:promoterapp/screen/StockEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promoterapp/screen/SalesReport.dart';
import 'package:promoterapp/screen/Attendance.dart';
import 'package:promoterapp/screen/Dashboard.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'dart:async';

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

      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: SlideDrawer(
        drawer: Container(
          color: Color(0xFF063A06),
          padding: EdgeInsets.only(left: 0, top: 100, right: 10),
          child: Column(
            children: [

              Row(
                children: [

                  Expanded(
                      flex: 1,
                      child: Image.asset(
                          'assets/Images/logo.png', height: 40)),

                  Expanded(
                    flex: 3,
                    child: Text("Welcome", style: TextStyle(fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w900)),)

                ],
              ),

              Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: ListTile(
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
                      style: TextStyle(color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600),
                    ),
                  )
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
                  style: TextStyle(color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/shop.png', height: 25),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              SalesReport()));


                },
                title: Text(
                  'Sales Report',
                  style: TextStyle(color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

              //
              // ListTile(
              //   leading: Image.asset(
              //       'assets/Images/shop.png', height: 25),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (contextt) =>
              //                 StockEntry()));
              //
              //   },
              //   title: Text(
              //     'Stock Report',
              //     style: TextStyle(color: Colors.white,
              //         fontSize: 14,
              //         fontFamily: 'OpenSans',
              //         fontWeight: FontWeight.w600),
              //   ),
              // ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/shutdown.png', height: 25),
                onTap: () {
                  logout(context);
                },
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600),
                ),
              ),

            ],
          ),
        ),
        child: Dashboard(),
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
