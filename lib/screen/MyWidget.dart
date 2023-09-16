import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget{
  String skulist="";

  MyWidget(this.skulist);

  @override
  State<StatefulWidget> createState() {
    return MyWidgetState();
  }

}

class MyWidgetState extends State<MyWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
        padding: const EdgeInsets.only(left: 5, right: 5,top: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0)
            ),
            border: Border.all(color: Color(0xFF063A06))
        ),
        child: Column(
            children: [

              Container(
                  padding: EdgeInsets.only(left:10,top: 10,right:10,bottom: 10),
                  child:Row(
                    children: [

                      Flexible(
                        flex:3,
                        child:   Align(
                          alignment: Alignment.centerLeft,
                          child:  Text(widget.skulist,style: TextStyle(fontSize: 16,color: Colors.green)),
                        ),
                      ),

                      Flexible(
                        flex:1,
                        child:TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Pieces'
                          ),
                        ),
                      )

                    ],
                  )
              ),

            ]
        )
    );
  }

}

