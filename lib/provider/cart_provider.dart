import 'package:flutter/material.dart';

class CartData{
  final String id;
  final String title;
  final double price;
  int quantity;

  CartData({
    required this.id,
    required this.title,
    required this.price,
    this.quantity=1,
  });
}

class Cart_Provider with ChangeNotifier{
  Map<String,CartData> _items = Map<String,CartData>();

  int get itemCount {
    return _items.length;
  }
  double get totalAmount{
    double total=0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
     });
     return total;
  }
  Map<String, CartData> get items {
    return {..._items};
  }
  List<String> get keyList{
    return _items.keys.toList();
  }
  List<CartData> get valuesList{
    return _items.values.toList();
  }
  int indexCount(String id){
    return _items.containsKey(id) ?_items[id]!.quantity : 0;
    notifyListeners();
  }
  
  void addToCart(String itemId,String itemTitle,double itemPrice){
    if(_items.containsKey(itemId)){
      _items[itemId]?.quantity++;
      print(_items[itemId]?.quantity);
    }else{
      _items.putIfAbsent(
        itemId, 
        () => CartData(
          id: DateTime.now().toString(), 
          title: itemTitle, 
          price: itemPrice,
        ),
      );
    }
    
    notifyListeners();
  }
  
  void deleteItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }
  void clean(){
    _items={};
    notifyListeners();
  }
}