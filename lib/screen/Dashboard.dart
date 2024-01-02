import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:intl/intl.dart';
import 'package:promoterapp/config/Common.dart';
import 'package:promoterapp/models/Logindetails.dart';
import 'package:promoterapp/screen/LoginScreen.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/DatabaseHelper.dart';
import 'package:promoterapp/util/Shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:promoterapp/screen/SalesEntry.dart';

import '../util/functionhelper.dart';

class Dashboard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard>{

  TextEditingController dateController = TextEditingController();
  final DatabaseHelper dbManager = new DatabaseHelper();
  int version=0;
  String device="";
  String name="";
  List<Item> itemdata = [];
 //Logindetails? logindetails;
  bool _isLoading = false;
  Future<Logindetails>? userdetails;

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    askpermission();
    name = SharedPrefClass.getString(PERSON_NAME);
    userdetails = getuserdetails('Userdetails');
    Future.delayed(const Duration(milliseconds: 600), () {

      setState(() {
        _isLoading = false;
      });

    });

    getSKU('GetShopsItemData').then((value) => {

      savelocaldb(value)

    });

  }

  Future<void> savelocaldb(value) async {

    itemdata = value.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
    await DatabaseHelper.deleteall();
    int? id = await dbManager.insertdata(itemdata);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading?const Center(
          child:CircularProgressIndicator()
      ):Column(
        children: [

          Container(
            color: light_grey,
            height: 50,
            child: Row(
              children: [

                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: const Text("Target:",style: TextStyle(color: Colors.black,fontSize: 20),),
                    )
                ),

                Expanded(
                    flex: 1,
                    child: FutureBuilder<Logindetails>(
                      future: userdetails,
                      builder:(context,snapshot){
                          if(snapshot.hasData){
                            return Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text("${snapshot.data?.target} Ltrs",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                            );
                          }
                          return Container();
                      },
                    )
                ),

              ],
            ),
          ),

          Container(

            margin: EdgeInsets.only(left: 15,right: 15,top: 20),
            child: Center(
              child: Text("Welcome $name",style: TextStyle(color: Colors.black,fontSize: 18),),
            ),

          ),

          Container(
            margin: EdgeInsets.only(left: 15,right: 15,top: 20),
            decoration: const BoxDecoration(
                color: green,
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0))
            ),
            height: 50,
            child: const Center(
              child: Text("Achieved : 0.0 LTRS",style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 10,right: 10,top:10),
            height: 50,
            child: Row(
              children: [

                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: dateController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Select date',
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now().subtract(const Duration(days: 7)),
                                  lastDate: DateTime.now());
                              if (date != null) {

                                dateController.text = DateFormat('MM/dd/yyyy').format(date);

                              }
                            },

                          ),
                        ),

                      ),
                    )
                ),

                Expanded(
                  flex: 1,
                  child: Container(

                    margin: const EdgeInsets.only(left: 5, right: 10),
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: app_theme,
                      border: Border.all(
                          color: Color(0xFFEFE4E4)),
                    ),

                    child: const Center(
                      child: Text(
                        "submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  ),
                ),

              ],
            ),
          ),

        ],
       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          setState(() {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SalesEntry()));

          });
        },
        child: Icon(Icons.add),

      ),
     );
   }

  void logout(BuildContext ctx) {

    showDialog(
      context: ctx,
      builder: (BuildContext context) =>
          AlertDialog(
            content: const Text('Logout'),
            actions: <TextButton>[

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () async {

                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));

                },
                child: const Text('Yes'),
               )

             ],
          ));

  }

}

