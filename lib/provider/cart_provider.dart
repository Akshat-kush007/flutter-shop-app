import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity=1,
  });
}

class Cart_Provider with ChangeNotifier{
  Map<String,CartItem> _items = Map<String,CartItem>();

  int get itemCount {
    return _items.length;
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
        () => CartItem(
          id: DateTime.now().toString(), 
          title: itemTitle, 
          price: itemPrice,
        ),
      );
    }
    notifyListeners();
  }
  
}