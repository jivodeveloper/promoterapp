import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Shops.dart';
import 'package:promoterapp/models/logindetails.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:promoterapp/screen/Dashboard.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/models/saalesreport.dart';
import 'package:promoterapp/util/Shared_pref.dart';

Future<logindetails> login(context, String user,String pass) async {

  final progress = ProgressHUD.of(context);
  progress?.show();

  logindetails details;

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(Uri.parse(
      '${IP_URL}LoginSalesPerson?user=$user&password=$pass'),
      headers: headers);

  details = logindetails.fromJson(json.decode(response.body));

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

Future<void> markattendance(String status, String beatid,BuildContext context,File file,progress) async {

  try{

    int userid=0;
    userid = SharedPrefClass.getInt(USER_ID);

    var request = await http.MultipartRequest('POST', Uri.parse('${IP_URL}AddSalesPersonAttendance'));
    request.fields['personId']= userid.toString();
    request.fields['status']= status;
    request.fields['latitude']= SharedPrefClass.getDouble(latitude).toString();
    request.fields['longitude']= SharedPrefClass.getDouble(longitude).toString();
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);

    if(response.statusCode == 200){

      Fluttertoast.showToast(msg: responsedData.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      if(responsedData.contains("DONE")){

        progress.dismiss();
        present = true;
        wo = true;

      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen()));

    }else{

      Fluttertoast.showToast(msg: "Please contact admin!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }catch(e){

    Fluttertoast.showToast(msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }


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

void getuserdetails(String endpoint) async {

  int userid=0;

  logindetails details;
  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.post(Uri.parse('$IP_URL$endpoint?userId=$userid'));

  if (response.statusCode == 200) {

    details = logindetails.fromJson(json.decode(response.body));

    SharedPrefClass.setString(ATT_STATUS,details.attStatus.toString());
    SharedPrefClass.setInt(DISTANCE_ALLOWED,details.distanceAllowed!.toInt());
    SharedPrefClass.setInt(USER_ID, details.personId);
    SharedPrefClass.setString(PERSON_TYPE, details.personType.toString());
    SharedPrefClass.setString(PERSON_NAME, details.personName.toString());
    SharedPrefClass.setString(GROUP, details.group.toString());

  } else {

    throw Exception('Failed to load data');

  }

}

Future<dynamic> getSKU(String endpoint) async{

  int userid=0;
  userid = SharedPrefClass.getInt(USER_ID);

  var response = await http.get(Uri.parse('$IP_URL$endpoint?id=$userid'));
  final list = jsonDecode(response.body);
  return list;

}

Future<void> savepromotersale(String salesEntry,File file,File file1,File file2,BuildContext context) async {

  int userid=0;
  userid = SharedPrefClass.getInt(USER_ID);

  var request = await http.MultipartRequest('POST', Uri.parse('${IP_URL}SavePromoterSales'));
  request.fields['salesEntry']= userid.toString();
  request.files.add(await http.MultipartFile.fromPath('image', file.path));
  request.files.add(await http.MultipartFile.fromPath('image1', file1.path));
  request.files.add(await http.MultipartFile.fromPath('image2', file2.path));

  var response = await request.send();
  var responsed = await http.Response.fromStream(response);
  final responsedData = json.decode(responsed.body);

  if(response.statusCode == 200){

    Fluttertoast.showToast(msg: responsedData.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);


    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Dashboard()));


  }else{

    Fluttertoast.showToast(msg: "Please contact admin!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

}
