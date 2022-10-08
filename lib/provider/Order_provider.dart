import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderData {
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

class Order_Provider with ChangeNotifier {
  List<OrderData> _items = [];

  List<OrderData> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  String? _authToken;
  String? _userId;
 
  set authToken(String? value) {
  _authToken = value;
  }
  set userId(String? value) {
    _userId = value;
  }
  Future fetchAndSetOrders() {
    // print(_authToken);
    final List<OrderData> loadedOrders = [];
   final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");
    return http.get(url).then((responce) {
      // print(jsonDecode(responce.body));
      final eMap = jsonDecode(responce.body) as Map<String, dynamic>;
     
      if (eMap == null) {
        return;
      }
     
      eMap.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderData(
            id: orderId,
            total: orderData['total'],
            dateTime: DateTime.parse(orderData['dateTime']),
            cartItems: (orderData['cartItem'] as List<dynamic>)
                .map(
                  (item) => CartData(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });

    }).catchError((err) {
      throw err;

    }).whenComplete(() {
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future addOrder(List<CartData> cartItems, double total) {
    final time = DateTime.now();
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");

    return http
        .post(url,
            body: jsonEncode({

              'dateTime': time.toIso8601String(),
              'total': total.toStringAsFixed(2),
              'cartItem': cartItems.map((each) {
                return {
                  'id': each.id,
                  'price': each.price,
                  'quantity': each.quantity,
                  "title": each.title,
                };
              }).toList(),
            }))
        .then((responce) {
      _items.insert(
          0,
          OrderData(
              id: jsonDecode(responce.body)['name'],
              dateTime: time,
              total: total.toStringAsFixed(2),
              cartItems: cartItems));
      notifyListeners();
    }).catchError((err) {
      throw err;
    });

    // _items.insert(
    //     0,
    //     OrderData(
    //         cartItems: cartItems,
    //         dateTime: time,
    //         id: DateTime.now().toString(),
    //         total: total.toStringAsFixed(2)));
    // notifyListeners();
  }
}
