import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart_provider.dart';

class OrderData{
  String id;
  DateTime dateTime;
  String total;
  List<CartData> cartItems;

  OrderData({
    required this.cartItems,
    required this.dateTime,
    required this.id,
    required this.total,
  });
}
class Order_Provider with ChangeNotifier{
  List<OrderData> _items=[];

  List<OrderData> get items{
    return [..._items];
  }
  int get itemCount {
    return _items.length;
  }
  void addOrder(List<CartData> cartItems,double total){
    _items.insert(0, OrderData(
      cartItems: cartItems, 
      dateTime: DateTime.now(), 
      id: DateTime.now().toString(), 
      total: total.toStringAsFixed(2)));
      print(_items);
      notifyListeners();
  }
} 