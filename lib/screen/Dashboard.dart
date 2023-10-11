import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Color.dart';
import 'package:intl/intl.dart';
import 'package:promoterapp/screen/LoginScreen.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/DatabaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promoterapp/models/Item.dart';

class Dashboard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard>{

  TextEditingController dateController = TextEditingController();
  final DatabaseHelper dbManager = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    getuserdetails('Userdetails');

    getSKU('GetShopsItemData').then((value) => {
      savelocaldb(value)
    });

  }

  Future<void> savelocaldb(value) async {

    List<Item> itemdata = [];
    itemdata = value.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

    int? id = await dbManager.insertdata(itemdata);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              children: [

                Expanded(
                  flex:1,
                  child:Image.asset('assets/Images/jivo_logo.png',width: 40,height: 40,),
                ),

                Expanded(
                  flex:12,
                  child: const Text("  Dashboard", style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400,fontSize: 21)),
                )

              ],
            )
          ),
          actions: [

            IconButton(
              icon: Image.asset(
               'assets/Images/logout.png', height:40, width:25),
              onPressed: () {
                logout(context);
              },
            )

          ],
      ),
      body:Column(
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
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: const Text("0.0 Ltrs",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                    )
                ),

              ],
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
              child: Text("Achieved : 0.0 Ltrs",style: TextStyle(color: Colors.white,fontSize: 18),),
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
          ),
    );

  }

}

