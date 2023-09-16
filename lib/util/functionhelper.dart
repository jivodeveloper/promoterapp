import 'package:flutter/material.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Shops.dart';
import 'package:promoterapp/screen/MyWidget.dart';
import 'package:promoterapp/screen/SalesEntry.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart' as Permissionhandler;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:geolocator/geolocator.dart';

void getAttendanceStatus() async {

  String attStatus="";

  attStatus = SharedPrefClass.getString(ATT_STATUS);
  if(attStatus==""){

    pr = true;
    eod = false;
    wo = true;
    hd = true;

  }else if(attStatus=="P"){

    pr = false;
    wo = false;
    eod = true;
    hd = true ;

  }else if(attStatus=="EOD"){

    pr = false;
    eod = false;
    wo = false;
    hd = false;

  }else if(attStatus=="NOON"){

    pr = false;
    eod = true;
    wo = false;
    hd = false;

  }else if(attStatus=="WO"){

    pr = false;
    eod = false;
    wo = false;
    hd = false;

  }

}

// Future<void> showdialog(String status,context, List beatnamelist,List beatIdlist) async {
//
//   return showDialog(
//       context: context,
//       builder:(BuildContext context) {
//         return AlertDialog(
//           title: const Text('Attendance'),
//           content: const Text('Are you really present?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context, 'Cancel'),
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () =>
//                   gettodaysbeat(status,context,beatnamelist,beatIdlist),
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       }
//    );
//
// }
//
//
// Future<void> showbeat(String status,BuildContext contextt, List beatnamelist, List beatIdlist) async {
//
//   if(beatnamelist.length == 0){
//
//     Navigator.pop(contextt);
//
//     Fluttertoast.showToast(msg: "You don't have any beat! \n Please contact admin",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0);
//
//   }else{
//
//     Navigator.pop(contextt);
//
//     return showDialog<void>(
//       context: contextt,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         contextt = context;
//         return AlertDialog(
//           title: const Text('Select Shop'),
//           content:ListView.builder(
//               shrinkWrap: true,
//               itemCount: beatnamelist.length,
//               itemBuilder: (context,i){
//                 return GestureDetector(
//                     onTap: (){
//                       Navigator.pop(contextt);
//
//                       if(getdistance('','',beatnamelist[i],'')){
//
//                         selectFromCamera(status,beatnamelist[i].toString(),contextt);
//
//                       }else{
//
//                         Fluttertoast.showToast(msg: "Too far from store!",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.black,
//                             textColor: Colors.white,
//                             fontSize: 16.0);
//                       }
//
//
//                     },
//                     child: Container(
//                       padding:EdgeInsets.all(10),
//                       child: Text("${beatnamelist[i]}"),
//                     )
//                 );
//               }
//           ),
//         );
//       },
//     );
//
//   }
//
// }
//
// Future<void> gettodaysbeat(status,context, List beatnamelist,List beatIdlist) async {
//
//   print("value of list $beatnamelist");
//   int beatId = (SharedPrefClass.getInt(BEAT_ID)==0 ? -1 : SharedPrefClass.getInt(BEAT_ID));
//
//   if(beatId==0 || beatId ==-1){
//
//     showbeat(status,context,beatnamelist,beatIdlist);
//
//   }else{
//
//     markattendance(status,beatId.toString(),context,"" as File);
//
//   }
//
// }

Future<void> showdialogg(String status,context, List<Shops> listdata) async {

  return showDialog(
      context: context,
      builder:(BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance'),
          content: const Text('Are you really present?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  // gettodaysbeat(status,context,beatnamelist,beatIdlist),

              gettodaysbeatt(status,context,listdata),
              child: const Text('Yes'),
            ),
          ],
        );
      }
  );

}

Future<void> gettodaysbeatt(status,context, List<Shops> beatnamelist) async {

  print("value of list $beatnamelist");
  int beatId = (SharedPrefClass.getInt(BEAT_ID)==0 ? -1 : SharedPrefClass.getInt(BEAT_ID));

  if(beatId==0 || beatId ==-1){

   // showbeat(status,context,beatnamelist,beatIdlist);
    showbeatt(status,context,beatnamelist);
  }else{

    markattendance(status,beatId.toString(),context,"" as File);

  }

}

Future<void> showbeatt(String status,BuildContext contextt, List<Shops> beatnamelist) async {

  if(beatnamelist.isEmpty){

    Navigator.pop(contextt);

    Fluttertoast.showToast(msg: "You don't have any beat! \n Please contact admin",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }else{

    Navigator.pop(contextt);

    return showDialog<void>(
      context: contextt,
      barrierDismissible: false,
      builder: (BuildContext context) {
        contextt = context;
        return AlertDialog(
          title: const Text('Select Shop'),
          content:ListView.builder(
              shrinkWrap: true,
              itemCount: beatnamelist.length,
              itemBuilder: (context,i){
                return GestureDetector(
                    onTap: (){
                      Navigator.pop(contextt);
                      print("${SharedPrefClass.getDouble(latitude)}");
                      if(SharedPrefClass.getDouble(latitude)==0.0){

                        Fluttertoast.showToast(msg: "Please check your connection!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }else{
                        if(getdistance(SharedPrefClass.getDouble(latitude),SharedPrefClass.getDouble(longitude),double.parse(beatnamelist[i].latitude!),double.parse(beatnamelist[i].longitude!))){

                          selectFromCamera(status,beatnamelist[i].toString(),contextt);

                        }else{

                          Fluttertoast.showToast(msg: "Too far from store!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);

                        }
                      }


                    },
                    child: Container(
                      padding:EdgeInsets.all(10),
                      child: Text("${beatnamelist[i].retailerName}"),
                    )
                );
              }
          ),
        );
      },
    );

  }

}

selectFromCamera(String status, String beatid, contextt) async {

  var camerastatus = await Permissionhandler.Permission.camera.status;

  if(camerastatus.isDenied == true){

    Fluttertoast.showToast(msg: "Please allow camera permission!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    Map<Permissionhandler.Permission, Permissionhandler.PermissionStatus> statuses = await [
      Permissionhandler.Permission.camera
    ].request();

  }else{

    try{

        File? f;
        int userid=0;
        userid = SharedPrefClass.getInt(USER_ID);

        final cameraFile= await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);

        final now = new DateTime.now();
        String dir = path.dirname(cameraFile!.path);
        String newPath = path.join(dir,("$userid-${now.day}-${now.month}-${now.year}-${now.hour}${now.minute}${now.second}.jpg"));
        f = await File(cameraFile.path).copy(newPath);

        markattendance(status,beatid,contextt,f);

    }catch(e){

      print('Failed to pick image: $e');

    }

  }

}

Future<void> askpermission() async {

  var camerastatus = await Permissionhandler.Permission.camera.status;
  var locationstatus = await Permissionhandler.Permission.location.status;

  if (camerastatus.isGranted == false && locationstatus.isGranted == false) {

    Map<Permissionhandler.Permission, Permissionhandler.PermissionStatus> statuses = await [
      Permissionhandler.Permission.location,
      Permissionhandler.Permission.camera
    ].request();

  }else{

  }

}

Future<void> checkdistance() async {

  var camerastatus = await Permissionhandler.Permission.camera.status;
  var locationstatus = await Permissionhandler.Permission.location.status;

  if (camerastatus.isGranted == false && locationstatus.isGranted == false) {

    Map<Permissionhandler.Permission, Permissionhandler.PermissionStatus> statuses = await [
      Permissionhandler.Permission.location,
      Permissionhandler.Permission.camera
    ].request();

  }else{

  }

}

/*get distance*/
bool getdistance(lat1 ,lng1, lat2, lng2){

  bool isallowed = false;
  var distance = Distance();
  final totaldist = distance(LatLng(lat1,lng2), LatLng(lat2,lng2));

  int disallow = SharedPrefClass.getInt(DISTANCE_ALLOWED);

  print("$totaldist $disallow");

  if(disallow > totaldist){
    isallowed = true;
  }else{
    isallowed = false;
  }

  print("isallowed $isallowed");
  return isallowed;

}

Future<String> getdate(context) async{

  String dt= "";
  var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now());

  if (date != null) {

    dt = DateFormat('MM/dd/yyyy').format(date);

  }

  return dt;
}

/*sales entry*/
Future<void> showskudialog(context, List SKUlist,List SKUid) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      context = context;
      return AlertDialog(
        title: const Text('Select SKU'),
        content:ListView.builder(
            shrinkWrap: true,
            itemCount: SKUlist.length,
            itemBuilder: (context,i){
              return GestureDetector(

                  onTap: (){

                    Navigator.pop(context);

                  },

                  child: Container(
                    padding:const EdgeInsets.all(10),
                    child: Text("${SKUlist[i]}"),
                  )

              );
            }
        ),
      );
    },
  );

}

/*current date*/
String getcurrentdate(){

  String cdate = DateFormat("yyyy/MM/dd").format(DateTime.now());
  return cdate;

}

/*current location */
Position? currentPosition;

void getCurrentPosition(context) async {

  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return;

  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    currentPosition = position;

    SharedPrefClass.setDouble(latitude, position.latitude);
    SharedPrefClass.setDouble(longitude, position.longitude);

   // setState(() => currentPosition = position);
    _getAddressFromLatLng(currentPosition!);

  }).catchError((e) {
    debugPrint(e);
  });

}

Future<void> _getAddressFromLatLng(Position position) async {

  await Geocoding.placemarkFromCoordinates(
      currentPosition!.latitude, currentPosition!.longitude)
      .then((List<Geocoding.Placemark> placemarks) {
    Geocoding.Placemark place = placemarks[0];

    // setState(() {
    //
    //   _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    //
    // });

  }).catchError((e) {
    debugPrint(e);
  });

}

Future<bool> _handleLocationPermission(context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  print("serviceenabled $serviceEnabled");
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  print("persmision latitude ${permission}");

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));

      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}







