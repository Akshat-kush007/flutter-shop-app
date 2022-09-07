
import 'package:flutter/material.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/provider/product.dart';

class Product_Provider with ChangeNotifier{
  List<Product> _priveteList=DUMMY_PRODUCTS;

  List<Product> get list{
    return [..._priveteList];
  }
  //Methods to update this provider
  void addProduct(){
    //-------type here--------


    // this will notify instance on execution of this method,
    //so if data changes it will rebuild
    notifyListeners();
  }

  Product findById(String Id){
    return _priveteList.firstWhere((element) => element.id==Id);
  }
}