import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/config/Color.dart';

class MyWidget extends StatefulWidget{

  String skulist="",image="";
  int skuid;

  MyWidget(this.skulist,this.skuid,this.image);

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
        child: Column(
            children: [

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                ),
                elevation: 10,
                shadowColor: Colors.black,
                child:Container(
                     child:Column(
                        children: [

                        Container(
                          decoration: const BoxDecoration(
                            color: app_theme,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                          ),
                          padding: EdgeInsets.all(10),

                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.skulist,style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),

                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          child:Row(

                            children: [

                                Expanded(
                                  flex:1,
                                  child: Image.network(widget.image,width: 100,height: 100,),
                                ),

                                Expanded(
                                    flex:1,
                                    child:SizedBox(
                                        width: 10,
                                        child:TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              hintText: 'Pieces'
                                         ),
                                      ),
                                   )
                                )

                            ]

                          ),
                        )

                      ],
                    )
                ),
              )

           ]
       )
    );
  }

}

