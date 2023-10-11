import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:promoterapp/screen/Attendance.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/screen/MyWidget.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/DatabaseHelper.dart';
import 'package:promoterapp/util/Networkconnectivity.dart';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:promoterapp/util/functionhelper.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;
import 'package:geolocator/geolocator.dart';

class SalesEntry  extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return SalesEntryState();
  }

}

List dynamicList = [];

class SalesEntryState extends State<SalesEntry>{

  Position? currentPosition;
  String dt = "";
  List itemlist = [],itemid=[];
  final DatabaseHelper dbManager = new DatabaseHelper();
  final connectivityResult = Connectivity().checkConnectivity();
  NetworkConnectivity networkConnectivity =NetworkConnectivity();
  int _batteryLevel = 0,userid = 0,shopid=0;
  bool isturnedon=true;
  String attstatus="";
  List<Item> itemdata = [];

  @override
  void initState() {
    super.initState();

    getCurrentPosition();
    getsharedprefdata();

    getSKU('GetShopsItemData').then((value) => {

      SKUlist(value,context)

    });

    getBatteryLevel().then((value) => {
     _batteryLevel = value
    });

  }

  getsharedprefdata(){

    userid  = SharedPrefClass.getInt(USER_ID);
    attstatus = SharedPrefClass.getString(ATT_STATUS);
    shopid = SharedPrefClass.getInt(SHOP_NAME);
  }

  void getCurrentPosition() async {

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

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: (){

                  dynamicList.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()));

                },
                child: const Icon(Icons.arrow_back,color:Color(0xFF063A06)),
              ),
              title: const Text("Sales Entry", style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400)
              )
          ),
          body: attstatus=="P"?ProgressHUD(
              child:Builder(
                builder:(ctx)=>
                    Scaffold(
                      body: Container(

                          child: Column(
                            children: [

                              Container(
                                height: 50,
                                color: Colors.black12,
                                child: Row(
                                  children: [

                                    Expanded(
                                        flex: 1,
                                        child:GestureDetector(

                                          onTap: (){

                                            final progress = ProgressHUD.of(ctx);
                                            progress?.show();

                                            showskudialog(context,itemdata,progress);

                                           // if(connectivityResult==ConnectivityResult.none){


                                          //  }

                                            // else{
                                            //
                                            //   print("list size offline$connectivityResult");
                                            //   showskudialog(context,itemlist,itemid);
                                            //   progress?.dismiss();
                                            //
                                            // }

                                          },

                                          child: Container(

                                            child:const Center(
                                              child:Text("+",style: TextStyle(
                                                  fontSize: 25
                                              ),
                                              ),
                                            ),
                                          ),

                                        )
                                    ),

                                    Expanded(
                                        child:GestureDetector(

                                          onTap: (){
                                            getdate(context).then((value) => {
                                              setState((){
                                                dt =value;
                                              })
                                            });
                                          },

                                          child: Container(
                                            child: Center(
                                              child: Text(dt == ""?"Date" :dt,style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),

                                        )
                                    ),

                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: (){
                                            save();
                                          },
                                          child: Center(
                                            child: Text("SAVE",style: TextStyle(
                                                fontSize: 16
                                            ),
                                            ),
                                          ),
                                        )
                                    ),

                                  ],
                                ),
                              ),

                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dynamicList.length,
                                    itemBuilder: (_, index) =>
                                    dynamicList[index]
                                ),
                              ),

                            ],
                          )
                      ),
                    ),
              )
          ):AlertDialog(

            content:Wrap(
              children: [

                Image.asset('assets/Images/complain.png',width: 40,height: 40,),
                Container(
                  margin: EdgeInsets.all(10),
                  child:Text("First Mark Present"),
                )

              ],
            ),
            actions: <Widget>[

              TextButton(
                onPressed: () => {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen()))

                },
                child: const Text('Cancel'),
              ),

              TextButton(
                onPressed: () =>{

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Attendance()))

                },
                child: const Text('Ok'),
              ),

            ],

          )
      ),
      onWillPop:() async{

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contextt) =>
                      HomeScreen()));

          return new Future(() => true);
        }
    );
  }

  Future<void> SKUlist(value,context) async {

    itemdata = value.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

   // // int? id = await dbManager.insertdata(itemdata);
   //
   //  itemlist.clear();
   //  itemid.clear();
   //
   //  for(int i=0 ;i<itemdata.length;i++) {
   //
   //    itemlist.add(itemdata[i].itemName);
   //    itemid.add(itemdata[i].itemID);
   //
   //  }

  }

  Future<void> save() async {

    int userid = SharedPrefClass.getInt(USER_ID);
    List<Item> items = [];

    for(int i=0;i<dynamicList.length;i++){

     // items.add(SalesItem(int.parse(dropdownOptionsProvider.selecteditemid[i].toString()),int.parse(dropdownOptionsProvider.selecteditemorder[i].toString()),int.parse(dropdownOptionsProvider.selecteditemstock[i].toString()),0));

    }

    var salesentry=[{

      "personId":userid,
      "shopId":shopid,
      "timeStamp":getcurrentdate(),
      "latitude":currentPosition?.latitude,
      "longitude":currentPosition?.longitude,
      "battery":_batteryLevel,
      "GpsEnabled":"GPS",
      "accuracy" : currentPosition?.accuracy,
      "speed" : currentPosition?.speed,
      "provider" : "GPS",
      "altitude":currentPosition?.altitude,
      "items":[{
        "itemId":24,
        "itemPieces":2,
        "itemQuantity":1
       }]

    }];

    var body = json.encode(salesentry);
    print("${body.toString()}");
    // int id=0;
    //
    // dbManager.savesaledata(body.toString()).then((value) => id = value);
    //
    // if(id>0){
    //
    // }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()));

  }

  void addwidget(skUlist,itemid,imageurl) async{

    setState(() {
      dynamicList.add(MyWidget(skUlist,itemid,imageurl));
    });

  }

  Future<void> showskudialog(context, List<Item> SKUlist,progress) async {

    progress.dismiss();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return AlertDialog(
          title: const Text('Select SKU'),
          content: ListView.builder(
              shrinkWrap: true,
              itemCount: SKUlist.length,
              itemBuilder: (context,i){
                return GestureDetector(

                    onTap: (){

                      Navigator.pop(context);
                      addwidget(SKUlist[i].itemName,SKUlist[i].itemID,SKUlist[i].imageurl);

                    },

                    child: Container(
                      padding:const EdgeInsets.all(10),
                      child: Text("${SKUlist[i].itemName}"),
                    )

                );
              }
          )
        );
      },
    );

  }

}













