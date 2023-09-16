import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<int> selectedSKU= [];
  List<int> selectedpieces= [];

  /*add category*/
  void addDropdownOptions(int index,String option){
    // selectedSKU[index]=option;
    // notifyListeners();
  }

  /*add item*/
  void additemdropdown(int index,int id){

    if (selectedpieces.asMap().containsKey(index)) {

      selectedpieces[index] = id;

    } else {

      selectedpieces.insert(index,id);

    }

    notifyListeners();
  }

  /*clear all list*/
  void remove(){

    selectedSKU.clear();
    selectedpieces.clear();

    notifyListeners();
  }


}