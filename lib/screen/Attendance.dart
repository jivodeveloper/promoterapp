import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:promoterapp/screen/Dashboard.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/functionhelper.dart';
import '../config/Common.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'HomeScreen.dart';

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

  @override
  void initState() {
    super.initState();

    getAttendanceStatus();
    getallbeat('GetShopsData').then((value) => allbeatlist(value));
    getAttendanceStatus();

  }

  void allbeatlist(value){

    if(value.length == 0){

      Fluttertoast.showToast(msg: "You don't have any beat! \n Please contact admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Dashboard()));
      });

    }else{

      for(int i=0 ;i<value.length;i++){

        if(value[i].retailerName != ""){
          print("length${value.length}");
          setState(() {

            beatnamelist.add(value[i].retailerName.toString());
            beatIdlist.add(value[i].retailerID!.toInt());

          });



        }

      }

      beatnamelist = LinkedHashSet<String>.from(beatnamelist).toList();

      beatIdlist = LinkedHashSet<int>.from(beatIdlist).toList();

    }

  }

  @override
  Widget build(BuildContext context) {

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
            ProgressHUD(
                child:Builder(
                    builder: (context) => Scaffold(
                        body: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[

                                    GestureDetector(
                                      onTap: (){

                                       showdilaog("P",context,beatnamelist,beatIdlist);
                                      },
                                      child:Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color:  pr ? Colors.grey : const Color(0xff0e0e0e),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                            child:Text(
                                              "PRESENT",
                                              style: TextStyle(color:Colors.white
                                              ),
                                            )
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                       showdilaog("EOD",context,beatnamelist,beatIdlist);
                                      },
                                      child:  Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: eod ? Colors.grey : const Color(0xff0e0e0e),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                            child:Text("END OF DAY",style: TextStyle(
                                                color: Colors.white
                                            ),
                                            )
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
                                      onTap: (){
                                       showdilaog("HD",context,beatnamelist,beatIdlist);
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: hd ? Colors.grey : const Color(0xff0e0e0e),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                            child: Text("HALF DAY",style: TextStyle(
                                                color: Colors.white
                                            ),
                                            )
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                       showdilaog("WO",context,beatnamelist,beatIdlist);
                                      },
                                      child:Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: wo ? Colors.grey : const Color(0xff0e0e0e),
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

                              ]
                          ),
                        )
                    )
                )
            )
       ),
        onWillPop: () {

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

  // Future<bool> _handleLocationPermission(progress) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return false;
  //   }
  //   progress?.dismiss();
  //   return true;
  // }
  //
  // Future<void> showdilaog(String status) async {
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
  //
  //                   gettodaysbeat(status,context),
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         );
  //       }
  //   );
  // }
  //
  // Future<void> showbeat(String status,BuildContext contextt) async {
  //
  //   if(beatnamelist.length == 0){
  //
  //     Navigator.pop(contextt);
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
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         contextt = context;
  //         return AlertDialog(
  //           title: const Text('Select Beat'),
  //           content:ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: beatnamelist.length,
  //               itemBuilder: (context,i){
  //                 return GestureDetector(
  //                     onTap: (){
  //
  //                       markattendance(status,beatnamelist[i].toString(),contextt);
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
  // }
  //
  // Future<void> markattendance(String status, String beatname,BuildContext context) async {
  //
  //   Navigator.pop(context);
  //   for(int i=0;i<beatnamelist.length;i++){
  //     if(beatname == beatnamelist[i]){
  //       beatId = beatIdlist[i];
  //
  //     }
  //   }
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var response = await http.post(Uri.parse('${IP_URL}AddSalesPersonAttendanceV3?personId=$userid&status=$status&latitude=$lat&longitude=$lng&beatId=$beatId'), headers: headers);
  //
  //   if(response.statusCode == 200){
  //
  //     if(response.body=="DONE"){
  //
  //       setState(() {
  //         present = true;
  //         wo = true;
  //       });
  //
  //     }
  //
  //     Fluttertoast.showToast(msg: response.body.toString(),
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 HomeScreen(personName:"")));
  //
  //   }else{
  //
  //     Fluttertoast.showToast(msg: "Please contact admin!!",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //
  //   }
  //
  // }
  //
  // Future<void> gettodaysbeat(status,context) async {
  //
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //   beatId = (prefs.getInt(BEAT_ID)==0? -1 :prefs.getInt(BEAT_ID))!;
  //
  //   if(beatId==0 || beatId ==-1){
  //
  //     showbeat(status,context);
  //
  //   }else{
  //
  //     markattendance(status,beatId.toString(),context);
  //
  //   }
  //
  // }
  //
  // Future<void> getallbeat() async {
  //
  //   try {
  //
  //     final data = await getallshops('syncAllData2');
  //     print('API response: $data');
  //
  //   } catch (e) {
  //
  //     print('Error fetching data: $e');
  //
  //   }
  //
  // }

}
