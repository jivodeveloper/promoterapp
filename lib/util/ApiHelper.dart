import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Shops.dart';
import 'package:promoterapp/models/Logindetails.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/models/saalesreport.dart';
import 'package:promoterapp/util/Shared_pref.dart';

Future<Logindetails> login(context, String user,String pass) async {

  final progress = ProgressHUD.of(context);
  progress?.show();

  Logindetails details;

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(Uri.parse(
      '${IP_URL}LoginSalesPerson?user=$user&password=$pass'),
      headers: headers);

  details = Logindetails.fromJson(json.decode(response.body));

  try {

    if (response.statusCode == 200) {

      if (details.personId != 0) {

        try {

          if(details.personType.toString().contains("PROMOTER")){

            SharedPrefClass.setInt(USER_ID, details.personId);
            SharedPrefClass.setString(PERSON_TYPE, details.personType.toString());
            SharedPrefClass.setString(PERSON_NAME, details.personName.toString());
            SharedPrefClass.setString(GROUP, details.group.toString());
            SharedPrefClass.setString(DISTANCE_ALLOWED, details.distanceAllowed.toString());

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(),
              ),
            );

          }else{

            Fluttertoast.showToast(
                msg: "Please check username and password !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);

          }

          } catch (e) {

            //print("distanceallowed$e");

          }

        Fluttertoast.showToast(
            msg: "Successfully logged in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      } else {

        Fluttertoast.showToast(
          msg: "Please check your userid and password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      }

    } else {

      Fluttertoast.showToast(
        msg: "Please check your credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    }

  } catch (e) {

    Fluttertoast.showToast(
      msg: "$e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: black,
      textColor: white,
      fontSize: 16.0,
    );

  }

  progress?.dismiss();
  return details;

}

Future<dynamic> getallbeat(String endpoint) async{

  int userid=0;
  userid = SharedPrefClass.getInt(USER_ID);
  var response = await http.get(Uri.parse('$IP_URL$endpoint?id=$userid'));
  final list = jsonDecode(response.body);

  List<Shops> beatdata = [];
  beatdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

  return beatdata;

}

Future<List<saalesreport>> getreports(String endpoint,String from,String to) async {

  int userid=0;

  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.get(Uri.parse('$IP_URL$endpoint?personId=$userid&startdate=$from&enddate=$to'));
  final list = jsonDecode(response.body);

  List<saalesreport> beatdata = [];

  try{

    beatdata = list.map<saalesreport>((m) => saalesreport.fromJson(Map<String, dynamic>.from(m))).toList();

  }catch(e){
    print("beatlist $e");
  }

  return beatdata;

}

Future<Logindetails> getuserdetails(String endpoint) async {

  int userid=0;

  Logindetails details;
 // List<Logindetails> details = [];
  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.post(Uri.parse('$IP_URL$endpoint?userId=$userid'));
  final list = jsonDecode(response.body);

  if (response.statusCode == 200) {

    details = Logindetails.fromJson(json.decode(response.body));

  //  details = list.map<Logindetails>((m) => Logindetails.fromJson(Map<String, dynamic>.from(m))).toList();

    SharedPrefClass.setString(ATT_STATUS,details.attStatus.toString());
    SharedPrefClass.setInt(DISTANCE_ALLOWED,details.distanceAllowed!.toInt());
    SharedPrefClass.setInt(USER_ID, details.personId);
    SharedPrefClass.setString(PERSON_TYPE, details.personType.toString());
    SharedPrefClass.setString(PERSON_NAME, details.personName.toString());
    SharedPrefClass.setString(GROUP, details.group.toString());
    SharedPrefClass.setString(TARGET, details.target.toString());
    print("${details.target.toString()}");
  } else {

    throw Exception('Failed to load data');

  }

  return details;
}

Future<dynamic> checklatestversion(String endpoint,version,device) async{

  int userid=0;
  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.get(Uri.parse('$IP_URL$endpoint?id=$userid&appversion=$version&device=$device'));
  final list = jsonDecode(response.body);
  return list;

}

Future<dynamic> getSKU(String endpoint) async{

  int userid=0;
  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.get(Uri.parse('$IP_URL$endpoint?id=$userid'));
  final list = jsonDecode(response.body);
  return list;

}

Future<void> savepromotersale(String salesEntry,String file,String file1,String file2,BuildContext context,progress,dynamiclist) async {

  try{

    var request = await http.MultipartRequest('POST', Uri.parse('${IP_URL}SavePromoterSales2'));
    request.fields['salesEntry']= salesEntry.toString();
    request.files.add(await http.MultipartFile.fromPath('image', file));

    if(file1!=""){

      request.files.add(await http.MultipartFile.fromPath('image1', file1));
    }
    if(file2!=""){

      request.files.add(await http.MultipartFile.fromPath('image2', file2));
    }

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);

    print("${responsedData.toString()}");
    if(responsedData.contains("DONE")){

      progress.dismiss();

      Fluttertoast.showToast(msg: responsedData.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      dynamiclist.clear();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen()));

    }else{

      progress.dismiss();
      Fluttertoast.showToast(msg: "Please contact admin!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }catch(e){

    progress.dismiss();
    print("$e");

    Fluttertoast.showToast(msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

}
