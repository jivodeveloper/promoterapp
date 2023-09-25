import 'package:flutter/material.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/screen/MyWidget.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/DatabaseHelper.dart';
import 'package:promoterapp/util/Networkconnectivity.dart';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:promoterapp/util/functionhelper.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SalesEntry  extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return SalesEntryState();
  }

}

List dynamicList = [];

class SalesEntryState extends State<SalesEntry>{

  String dt = "";
  List itemlist = [],itemid=[];
  final DatabaseHelper dbManager = new DatabaseHelper();
  final connectivityResult = Connectivity().checkConnectivity();
  NetworkConnectivity networkConnectivity =NetworkConnectivity();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
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
              title: const Text("My Attendance",
                  style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400)
              )
          ),
          body: ProgressHUD(
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

                                           if(connectivityResult==ConnectivityResult.none){
                                             print("list size online$connectivityResult");

                                             getSKU('GetShopsItemData').then((value) => {

                                               SKUlist(value,context,progress)

                                             });

                                           }else{
                                             print("list size offline$connectivityResult");
                                             var list = [];

                                             showskudialog(context,itemlist,itemid);

                                           }

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

                                        },
                                        child: Container(
                                          child: Center(
                                            child: Text("SAVE",style: TextStyle(
                                                fontSize: 16
                                            ),),
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
          )
        ),
    );
  }

  Future<void> SKUlist(value,context, progress) async {

    progress.dismiss();

    List<Item> itemdata = [];
    itemdata = value.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

    int? id = await dbManager.insertdata(itemdata);

    print("id value $id");
    itemlist.clear();
    itemid.clear();

    for(int i=0 ;i<itemdata.length;i++) {

      itemlist.add(itemdata[i].itemName);
      itemid.add(itemdata[i].itemID);

    }

    showskudialog(context,itemlist,itemid);

  }

  void savesave(){

    int userid = SharedPrefClass.getInt(USER_ID);

    // var salesentry=[{
    //   "personId":userid,
    //   "shopId":widget.retailerId,
    //   "timeStamp":getcurrentdate(),
    //   "itemId":widget.status,
    //   "itemPieces":_currentPosition?.latitude,
    //   "itemQuantity":_currentPosition?.longitude,
    //   "latitude":_batteryLevel,
    //   "longitude":isturnedon,
    //   "battery":_currentPosition?.accuracy,
    //   "GpsEnabled":_currentPosition?.speed,
    //   "accuracy":_currentPosition?.provider,
    //   "speed":_currentPosition?.altitude,
    //   "provider":shoptype,
    //   "altitude":"secondary",
    // }];
    //
    // var body = json.encode(salesentry);

  }

  void addwidget(skUlist) async{

    setState(() {
      dynamicList.add(MyWidget(skUlist));
    });

  }

  Future<void> showskudialog(context, List SKUlist,List SKUid) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        context = context;
        return AlertDialog(
          title: const Text('Select SKU'),
          content:FutureBuilder<String>(
            future: networkConnectivity.checkConnectivity(),
            builder: (context,snapshot) {
              if(snapshot.hasData){
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context,i){
                      return GestureDetector(

                          onTap: (){

                            Navigator.pop(context);
                            addwidget(snapshot.data?[i].);
                          },

                          child: Container(
                            padding:const EdgeInsets.all(10),
                            child: Text("${SKUlist[i]}"),
                          )

                      );
                    }
                );
              }
            },
          )
        );
      },
    );

  }

}













