import 'dart:async';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:promoterapp/models/Shops.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/functionhelper.dart';
import '../config/Common.dart';
import '../util/Shared_pref.dart';
import 'HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart' as Permissionhandler;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget{

    @override
    State<StatefulWidget> createState() {
      return AttendanceState();
    }

}

class AttendanceState extends State<Attendance>{

  double? lat ,lng;
  List beatnamelist = [];
  List<int> beatIdlist = [];
  int userid=0,beatId=0;
  String attStatus="";
  bool _isLoading = false;
  get progress => null;
  List<Shops> shopdata = [];
  bool cstatus = false ,lstatus =false,gpsstatus=false;
  Location location = new Location();
  Timer? timer;
  File? f;

  @override
  void initState() {
    super.initState();

    askpermission();
    getCurrentPosition(context);
    getAttendanceStatus();
    setState(() {
      _isLoading = true;
    });
    getallbeat('GetShopsData').then((value) => allbeatlist(value));

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> askpermission() async {

    try{

      var camerastatus = await Permissionhandler.Permission.camera.status;
      var locationstatus = await Permissionhandler.Permission.locationWhenInUse.status;

      if (camerastatus.isGranted == false || locationstatus.isGranted == false) {

        Map<Permissionhandler.Permission, Permissionhandler.PermissionStatus> statuses = await [
          Permissionhandler.Permission.location,
          Permissionhandler.Permission.camera
        ].request();

      }

      if(camerastatus.isGranted==true){
        cstatus = true;

      }

      if(locationstatus.isGranted == true){
        lstatus = true;

      }

      bool ison = await location.serviceEnabled();

      if (!ison) {

        bool isturnedon = await location.requestService();

        if (isturnedon) {
          gpsstatus = true;
          print("gpsstatus$gpsstatus");
        }else{
          print("gpsstatus$isturnedon");
        }

      }else{

        gpsstatus = true;

      }

    }catch(e){

      print("gpsstatus$e");

    }

  }

  void allbeatlist(value){

    if(value.length == 0){

      Future.delayed(Duration(seconds: 3), () {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen()));

      });

      Fluttertoast.showToast(msg: "You don't have any beat! \n Please contact admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{

      shopdata = value;
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext ctx) {

    return WillPopScope(

        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: (){

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen()));

                  },
                  child: const Icon(Icons.arrow_back,color:Color(0xFF063A06)),
                ),
                title: const Text("My Attendance",
                    style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400)
                )
            ),
            body:_isLoading?const Center(
                child:CircularProgressIndicator()
            ):
            Scaffold(
                body: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[

                            GestureDetector(
                              onTap: penabled? (){

                                if(cstatus==false){

                                  Fluttertoast.showToast(msg: "Please allow camera permission");

                                }else if(lstatus ==false){

                                  Fluttertoast.showToast(msg: "Please allow location permission");

                                }else{

                                  setState(() {
                                    _isLoading=true;
                                  });

                                  showdialogg("P",ctx,shopdata);

                                }

                              }:null,
                              child:Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:  present ? const Color(0xff0e0e0e) : Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child:Text(
                                      "PRESENT",
                                      style: TextStyle(color:Colors.white),
                                    )
                                ),
                              ),
                            ),

                            GestureDetector(

                              onTap: eodenabled?(){

                                setState(() {
                                  _isLoading=true;
                                });

                                // final progress  = ProgressHUD.of(ctx);
                                // progress?.show();
                                showdialogg("EOD",ctx, shopdata);

                                // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => {
                                //
                                //   if(_isLoading==false){
                                //
                                //     timer?.cancel(),
                                //
                                //
                                //   }
                                //
                                // });
                              }:null,

                              child:Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: eod ? const Color(0xff0e0e0e):Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child:Text("END OF DAY",style: TextStyle(color: Colors.white),)
                                ),
                              ),

                            ),

                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[

                            GestureDetector(
                              onTap: hdenabled?(){

                                if(cstatus==false){

                                  Fluttertoast.showToast(msg: "Please allow camera permission");

                                }else if(lstatus ==false){

                                  Fluttertoast.showToast(msg: "Please allow location permission");

                                }else{
                                  setState(() {
                                    _isLoading=true;
                                  });

                                  showdialogg("NOON",ctx,shopdata);

                                }

                              }:null,

                              child: Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: hd ?  const Color(0xff0e0e0e) : Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child: Text("MID DAY",style: TextStyle(
                                        color: Colors.white
                                    ),
                                    )
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap:woenabled? (){

                                setState(() {
                                  _isLoading=true;
                                });
                                showdialogg("WO",context,shopdata);

                                // try{
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (ctx) =>
                                //               HomeScreen()));
                                // }catch(e){
                                //   print("print image $e");
                                // }
                              }:null,
                              child:Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: wo ?  const Color(0xff0e0e0e):Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child: Text("WEEK OFF",style: TextStyle(
                                        color: Colors.white
                                    ),
                                    )
                                ),
                              ),
                            )

                          ],

                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            GestureDetector(
                              onTap:abenabled?(){

                                setState(() {
                                  _isLoading=true;
                                });

                                showdialogg("A",ctx,shopdata);

                              }:null,
                              child: Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ab ?  const Color(0xff0e0e0e) : Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child: Text("ABSENT",style: TextStyle(
                                        color: Colors.white
                                    ),
                                    )
                                ),
                              ),
                            )

                          ],
                        )

                     ]

                  ),
                )
            )
        ),
        onWillPop: () {

          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contextt) =>
                      HomeScreen()
              )
          );

          return new Future(() => true);

        }

    );

  }

  Future<void> showdialogg(String status,BuildContext ctx, List<Shops> listdata) async {

    return showDialog(

        barrierDismissible: false,
        context: context,
        builder:(BuildContext context) {
          ctx = context;
          return AlertDialog(
            title: const Text('Attendance'),
            content:status=="P"||status=="NOON"?Text('Are you really present?'):Text('Are you sure?'),
            actions: <Widget>[

              TextButton(
                onPressed: () => {
                  Navigator.pop(context, 'Cancel'),
                  setState(() {
                    _isLoading = false;
                  })
                 // progress!.dismiss()
                },
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () =>{

                  if(status=="P" || status=="NOON" ||status=="EOD"){

                    gettodaysbeatt(status,ctx,listdata),

                  }else{

                     markattendance(status,beatId.toString(),context,f)

                  }

                },

                child: const Text('Yes'),
              ),

            ],

          );

        }

    );

  }

  Future<void> gettodaysbeatt(status,context,List<Shops> beatnamelist) async {

    int beatId = (SharedPrefClass.getInt(BEAT_ID)==0 ? -1 : SharedPrefClass.getInt(BEAT_ID));

    if(beatId==0 || beatId ==-1 ){

      //showbeat(status,context,beatnamelist,beatIdlist);
      showbeatt(status,context,beatnamelist);

    }else{

      markattendance(status,beatId.toString(),context,"" as File);

    }

  }

  Future<void> showbeatt(String status,BuildContext contextt, List<Shops> beatnamelist) async {

    if(beatnamelist.isEmpty){

      Navigator.pop(contextt);

      Fluttertoast.showToast(msg: "No shop assigned",
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
          return WillPopScope(
              child: SizedBox(
                height: 300,
                child: AlertDialog(
                  title: const Text('Select Shop'),
                  content: ListView.builder(
                      shrinkWrap: true,
                      itemCount: beatnamelist.length,
                      itemBuilder: (context,i){
                        return GestureDetector(

                            onTap: (){

                              Navigator.pop(contextt);

                              if(SharedPrefClass.getDouble(latitude)==0.0){

                                Fluttertoast.showToast(msg: "Please check your connection!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                              }else{


                                print("locationlatitude ${SharedPrefClass.getDouble(latitude)}  ${SharedPrefClass.getDouble(longitude)} ${double.parse(beatnamelist[i].latitude!)} ${double.parse(beatnamelist[i].longitude!)}");

                                if(getdistance(SharedPrefClass.getDouble(latitude),SharedPrefClass.getDouble(longitude),double.parse(beatnamelist[i].latitude!),double.parse(beatnamelist[i].longitude!))){

                                  SharedPrefClass.setInt(SHOP_ID,beatnamelist[i].retailerID!.toInt());
                                  selectFromCamera(status,beatnamelist[i].toString(),contextt);

                                }else{

                                  setState(() {
                                    _isLoading=false;
                                  });

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
                ),
              ),
              onWillPop: () {

                setState(() {
                  _isLoading = false;
                });

                return new Future(() => true);

              });
        },
      );

    }

  }

  selectFromCamera(String status, String beatid,BuildContext contextt) async {

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


        int userid=0;
        userid = SharedPrefClass.getInt(USER_ID);

        final cameraFile= await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);

        final now = new DateTime.now();
        String dir = path.dirname(cameraFile!.path);
        String newPath = path.join(dir,("$userid-${now.day}-${now.month}-${now.year}-${now.hour}${now.minute}${now.second}.jpg"));
        f = await File(cameraFile.path).copy(newPath);

        markattendance(status,beatid,contextt,f!);

      }catch(e){

        print('Failed to pick image: $e');

      }

    }

  }

  Future<void> markattendance(String status, String beatid,BuildContext ctx,File? file) async {

    try{

      int userid=0;
      userid = SharedPrefClass.getInt(USER_ID);

      var request = await http.MultipartRequest('POST', Uri.parse('${IP_URL}AddSalesPersonAttendance'));
      request.fields['personId']= userid.toString();
      request.fields['status']= status;
      request.fields['latitude']= SharedPrefClass.getDouble(latitude).toString();
      request.fields['longitude']= SharedPrefClass.getDouble(longitude).toString();

      if(file != null){
        request.files.add(await http.MultipartFile.fromPath('image', file.path));
      }

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

          SharedPrefClass.setString(ATT_STATUS,status);

          setState(() {
            _isLoading=false;
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()));

        }

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

      print("print image $e");

    }


  }

}

