import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/screen/MyWidget.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/functionhelper.dart';

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

                                  getSKU('GetShopsItemData').then((value) => {
                                    SKUlist(value,context)
                                  });
                                },

                                child: Container(
                                  color: Colors.black12,
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
    );
  }

  void SKUlist(value,context){

    List<Item> itemdata = [];
    itemdata = value.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

    itemlist.clear();
    itemid.clear();

    for(int i=0 ;i<itemdata.length;i++) {

      itemlist.add(itemdata[i].itemName);
      itemid.add(itemdata[i].itemID);

    }

    showskudialog(context,itemlist,itemid);

  }

  void addwidget(skUlist) async{

    //setState(() {
    dynamicList.add(MyWidget(skUlist));
    //});

  }

  void savesave(){

    var salesentry=[{
      "personId":userid,
      "shopId":widget.retailerId,
      "timeStamp":cdate,
      "itemId":widget.status,
      "itemPieces":_currentPosition?.latitude,
      "itemQuantity":_currentPosition?.longitude,
      "latitude":_batteryLevel,
      "longitude":isturnedon,
      "battery":_currentPosition?.accuracy,
      "GpsEnabled":_currentPosition?.speed,
      "accuracy":_currentPosition?.provider,
      "speed":_currentPosition?.altitude,
      "provider":shoptype,
      "altitude":"secondary",
    }];

    var body = json.encode(salesentry);

  }

}






