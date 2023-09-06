import 'package:flutter/material.dart';
import 'package:promoterapp/config/Common.dart';
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

void getAttendanceStatus() async {

  String attStatus="";

  attStatus = SharedPrefClass.getString(ATT_STATUS);

  if(attStatus=="P"){

    pr = true;
    wo = true;

  }else if(attStatus=="EOD"){

    pr = true;
    eod = true;
    wo = true;
    hd = true;

  }else if(attStatus=="HD"){

    pr = true;
    eod = true;
    wo = true;
    hd = true;

  }else if(attStatus=="EOD"){

    pr = true;
    eod = true;
    wo = true;
    hd = true;

  }

}

Future<void> x(String status,context, List beatnamelist,List beatIdlist) async {

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
                  gettodaysbeat(status,context,beatnamelist,beatIdlist),
              child: const Text('Yes'),
            ),
          ],
        );
      }
   );

}

Future<void> showbeat(String status,BuildContext contextt, List beatnamelist, List beatIdlist) async {

  if(beatnamelist.length == 0){

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
                      if(getdistance('','',beatnamelist[i],'')){

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


                    },
                    child: Container(
                      padding:EdgeInsets.all(10),
                      child: Text("${beatnamelist[i]}"),
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

Future<void> gettodaysbeat(status,context, List beatnamelist,List beatIdlist) async {

  print("value of list $beatnamelist");
  int beatId = (SharedPrefClass.getInt(BEAT_ID)==0 ? -1 : SharedPrefClass.getInt(BEAT_ID));

  if(beatId==0 || beatId ==-1){

    showbeat(status,context,beatnamelist,beatIdlist);

  }else{

    markattendance(status,beatId.toString(),context,"" as File);

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

bool getdistance(lat1 ,lng1, lat2, lng2){

  bool isallowed = false;
  var distance = Distance();
  final totaldist = distance(LatLng(lat1,lng2), LatLng(lat2,lng2));

  int disallow = SharedPrefClass.getInt(DISTANCE_ALLOWED);

  if(disallow > totaldist){
    isallowed = true;
  }else{
    isallowed = false;
  }

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
                    //addwidget(SKUlist[i].toString());
                  },

                  child: Container(
                    padding:EdgeInsets.all(10),
                    child: Text("${SKUlist[i]}"),
                  )

              );
            }
        ),
      );
    },
  );

}

String getcurrentdate(){

  String cdate = DateFormat("yyyy/MM/dd").format(DateTime.now());
  return cdate;

}





