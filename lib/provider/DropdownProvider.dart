import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<int> SKUid= [];
  List<int> selectedpieces= [];

  /*add category*/
  void addDropdownOptions(int index,String option){
    // selectedSKU[index]=option;
    // notifyListeners();
  }

  /*add item*/
  void additemdropdown(int index,int pcs,int schemeid){

    if (selectedpieces.asMap().containsKey(index)) {
      selectedpieces[index] = pcs;
      SKUid[index] = schemeid;
    } else {
      selectedpieces.insert(index,pcs);
      SKUid.insert(index,schemeid);
    }

    notifyListeners();
  }

  /*clear all list*/
  void remove(){

    SKUid.clear();
    selectedpieces.clear();

    notifyListeners();
  }

}