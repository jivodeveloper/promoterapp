import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<int> SKUid= [];
  List<int> selectedpieces= [];
  List<num> selectedquantity= [];

  /*add category*/
  void addDropdownOptions(int index,String option){
    // selectedSKU[index]=option;
    // notifyListeners();
  }

  /*add item*/
  void additemdropdown(int index,int pcs,int schemeid,num quanity){

    if (selectedpieces.asMap().containsKey(index)) {

      selectedpieces[index] = pcs;
      SKUid[index] = schemeid;
      selectedquantity[index] = quanity;

    } else {

      selectedpieces.insert(index,pcs);
      SKUid.insert(index,schemeid);
      selectedquantity.insert(index,quanity);

    }

    notifyListeners();
  }

  /*clear all list*/
  void remove(){

    SKUid.clear();
    selectedpieces.clear();
    selectedquantity.clear();
    notifyListeners();
  }

}