import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/provider/DropdownProvider.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatelessWidget{

  String skulist="",image="";
  int skuid,idx=0;
  num quantity=0.0;

  MyWidget(this.skulist,this.skuid,this.image,this.idx,this.quantity);

  TextEditingController pieces = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final dropdownOptionsProvider = Provider.of<DropdownProvider>(context);

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
        child: Column(
            children: [

              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),),
                elevation: 10,
                shadowColor: Colors.black,
                child:Column(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(skulist,style: TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      child:Row(

                          children: [

                            Expanded(
                              flex:3,
                              child: Image.network(image,width: 50,height: 100),
                            ),

                            Expanded(
                                flex: 1,
                                child:SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: pieces,
                                    onChanged: (value){
                                      dropdownOptionsProvider.additemdropdown(idx, int.parse(value), skuid,quantity);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "Pieces"
                                    ),
                                    style: TextStyle(fontSize: 16.0, height: 2.0, color: Colors.black),
                                  ),
                                )
                             ),

                            // Expanded(
                            //     flex: 1,
                            //     child:GestureDetector(
                            //       onTap: (){
                            //         // dynamicList.remove(MyWidget("",0,""));
                            //       },
                            //       child: Image.asset('assets/Images/close.png',width: 20,height: 20,),
                            //     )
                            // ),

                         ]

                      ),
                    )

                  ],
                ),
              )

           ]
        )
    );

  }

}


