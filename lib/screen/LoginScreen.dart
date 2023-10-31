import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:promoterapp/util/functionhelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {

  StreamSubscription? connection;
  bool isoffline = false;
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    askpermission();
  }

  @override
  void dispose() {
    connection!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: ProgressHUD(
                child: Builder(
                  builder: (ctx) =>
                      Scaffold(
                        body: Container(
                          color: Colors.white,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      children: [

                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Proceed with your",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF063A06),
                                                  fontSize: 20,
                                                ),
                                              )
                                          ),
                                        ),

                                        const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "LOGIN", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF063A06),
                                              fontSize: 30,
                                             ),
                                            )
                                         )

                                      ],
                                    ),
                                  ),

                                  Form(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 20, 10, 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFEFE4E4))
                                            ),
                                            child: TextFormField(
                                              controller: usercontroller,
                                              decoration: InputDecoration(
                                                  prefixIcon: Icon(Icons.lock,
                                                    color: Color(0xFF063A06),),
                                                  hintText: 'username'
                                              ),
                                            ),
                                          ),

                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFEFE4E4))
                                            ),
                                            child: TextFormField(
                                              controller: passcontroller,
                                              obscureText: _obscureText,
                                              keyboardType: TextInputType.text,
                                              decoration : InputDecoration(
                                                prefixIcon : Icon(Icons.password,
                                                  color : Color(0xFF063A06),),
                                                hintText : 'password',
                                                suffixIcon : GestureDetector(
                                                  onTap : () {
                                                    setState(() {
                                                      _obscureText = !_obscureText;
                                                    });
                                                  },
                                                  child : Icon(
                                                    _obscureText
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    semanticLabel:
                                                    _obscureText
                                                        ? 'show password'
                                                        : 'hide password',
                                                    color: Color(0xFF063A06),
                                                  ),
                                                ),
                                              ),

                                            ),
                                          )

                                        ],
                                      )
                                  ),

                                  GestureDetector(

                                    onTap: () async {
                                      login(ctx, usercontroller.text,passcontroller.text);
                                    },

                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 40, right: 10, bottom: 10),
                                      width: double.infinity,
                                      height: 55,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF063A06),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))
                                      ),

                                      child: const Center(
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),

                                    ),

                                  )

                                ],

                              ),
                            ),
                          ),
                        ),
                    ),
                )
            )
         ),
        onWillPop: () async{
          return false;
        }
    );
  }

  void logout() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure?'),
            actions: <Widget>[

              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () async {

                  SharedPreferences preferences = await SharedPreferences
                      .getInstance();
                  preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));

                },
                child: const Text('Yes'),
              ),

            ],
          );
        }
    );
  }

}

