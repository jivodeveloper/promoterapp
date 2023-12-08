import 'dart:convert';
import 'dart:io';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/SalesItem.dart';
import 'package:promoterapp/screen/Attendance.dart';
import 'package:promoterapp/screen/HomeScreen.dart';
import 'package:promoterapp/util/DatabaseHelper.dart';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:promoterapp/util/functionhelper.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import '../provider/PromoterStockProvider.dart';
import 'StockWidget.dart';

List dynamicList = [];
class StockEntry extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return StockEntryState();
  }

}

class StockEntryState extends State<StockEntry>{

  String attstatus = "";
  String dt = "";
  List allitems = [];
  int idx=0,shopid = 0,_batteryLevel = 0;

  @override
  void initState() {

    super.initState();
    getsharedprefdata();
    getofflinedata();

  }
    getsharedprefdata(){

    attstatus = SharedPrefClass.getString(ATT_STATUS);
    shopid = SharedPrefClass.getInt(SHOP_ID);

  }

  getofflinedata() async{

    allitems.clear();
    allitems = await DatabaseHelper.getItems();

  }

  @override
  Widget build(BuildContext context) {

    final dropdownOptionsProvider = Provider.of<PromoterStockProvider>(context);

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

               title: const Text("Stock Entry", style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400))
           ),

           body: attstatus=="P" || attstatus=="NOON"? ProgressHUD(
               child:Builder(
                 builder:(ctx)=>
                     Scaffold(
                       body: Column(
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

                                           // final progress = ProgressHUD.of(ctx);
                                           // progress?.show();

                                           showskudialog(context,allitems);

                                         },

                                         child:Container(
                                           child:  const Center(
                                             child:Text("+",style: TextStyle(
                                                 fontSize: 25
                                             ),
                                             ),
                                           ),
                                         )

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

                                          final progress  = ProgressHUD.of(ctx);

                                          save(dropdownOptionsProvider,context,progress);

                                         },

                                         child:const Center(
                                           child:Text("SAVE",style: TextStyle(
                                               fontSize: 16
                                              ),
                                           ),
                                        )

                                     )
                                 ),

                               ],
                             ),
                           ),

                           // Row(
                           //   children: [
                           //
                           //     Expanded(
                           //       flex: 1,
                           //       child: InkWell(
                           //           onTap: (){
                           //             selectFromCamera("image");
                           //           },
                           //           child: Container(
                           //             padding: EdgeInsets.all(5),
                           //             height: 100,
                           //             child: DottedBorder(
                           //               color:grey,
                           //               strokeWidth: 1,
                           //               child:Center(
                           //                   child:cameraFile==null?Image.asset('assets/Images/plus.png',height: 15):Image.file(File(cameraFile!.path),width: MediaQuery.of(context).size.width)
                           //               ),
                           //             ),
                           //           )
                           //       ),
                           //     ),
                           //
                           //     Expanded(
                           //         flex: 1,
                           //         child:InkWell(
                           //           onTap: (){
                           //             selectFromCamera("image1");
                           //           },
                           //           child: Container(
                           //             padding: EdgeInsets.all(5),
                           //             height: 100,
                           //             child: DottedBorder(
                           //                 color:grey,
                           //                 strokeWidth: 1,
                           //                 child:Center(
                           //                     child:cameraFile1==null?Image.asset('assets/Images/plus.png',height: 15):Image.file(File(cameraFile1!.path))
                           //
                           //                 )
                           //             ),
                           //           ),
                           //         )
                           //     ),
                           //
                           //     Expanded(
                           //         flex: 1,
                           //         child:InkWell(
                           //           onTap: (){
                           //             selectFromCamera("image2");
                           //           },
                           //           child: Container(
                           //             padding: EdgeInsets.all(5),
                           //             height: 100,
                           //             child: DottedBorder(
                           //                 color:grey,
                           //                 strokeWidth: 1,
                           //                 child:Center(
                           //                     child:cameraFile2==null?Image.asset('assets/Images/plus.png',height: 15):Image.file(File(cameraFile2!.path))
                           //
                           //                 )
                           //             ),
                           //           ),
                           //         )
                           //     ),
                           //
                           //   ],
                           // ),

                           Expanded(
                             child: ListView.builder(
                                 shrinkWrap: true,
                                 itemCount: dynamicList.length,
                                 itemBuilder: (_, index) =>
                                 dynamicList[index]
                             ),
                           ),

                         ],
                      ),
                   ),
               )
           ):AlertDialog(
             content:Wrap(
              children: [

                 Image.asset('assets/Images/complain.png',width: 40,height: 40),
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
         return new Future(() => true);
       }
    );
  }

  Future<void> showskudialog(context, List SKUlist) async {

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
                      addwidget(SKUlist[i]['itemName'],SKUlist[i]['itemID'],SKUlist[i]['imageurl'],num.parse(SKUlist[i]['quantity']));

                    },

                    child: Container(

                      padding:const EdgeInsets.all(10),
                      child: Text("${SKUlist[i]['itemName']}"),

                    )

                );
             }

          ),

        );

      },

    );

  }

  void addwidget(skUlist,itemid,imageurl,num quantity) async{

    setState(() {
      dynamicList.add(StockWidget(skUlist,itemid,imageurl,idx,quantity));
    });

    idx++;

  }

  Future<void> save(PromoterStockProvider dropdownOptionsProvider,context,progress) async {

    int userid = SharedPrefClass.getInt(USER_ID);
    List<SalesItem> items = [];

    int i = 0 ;
    dynamicList.forEach((widget) {

      String pieces = widget.pieces.text;

      if (pieces != "") {
        i++;
      }

    });

    if(dynamicList.length==0){

      Fluttertoast.showToast(msg: "Please select SKU");

    }else if(i!=dynamicList.length){

      Fluttertoast.showToast(msg: "Please enter pieces");

    }else if(dt==""){

      Fluttertoast.showToast(msg: "Please select date");

    }else {

      progress?.show();

      for (int i = 0; i < dynamicList.length; i++) {

        // items.add(
        //     StockItem(
        //      int.parse(dropdownOptionsProvider.itemName[i].toString()),
        //      int.parse(dropdownOptionsProvider.itemId[i].toString()),
        //      dropdownOptionsProvider.quant[i])
        // );

      }

      var salesentry = [{

        "itemName": userid,
        "itemid": shopid,
        "stock": currentPosition?.latitude,
        "timeStamp": dt,

      }];

      var body = json.encode(salesentry);

      print("bodytostring ${body.toString()}");

    }

  }

}