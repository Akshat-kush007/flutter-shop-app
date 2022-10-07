import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool favourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.favourite = false,
  });

  Future toggleFavourite(String id) async {
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/products/$id.json");
    favourite = !favourite;
    notifyListeners();

    try {
      Response res =
          await http.patch(url, body: jsonEncode({'favourite': favourite}));
      //Error dectaction for patch request -> throw a custom ERROR!!
      if (res.statusCode >= 400) {
        print("ERROR");
        throw (HttpException("Error occurs !!"));
      }
      //Catching the error due to network & patch -> and then throw back!!
    } catch (err) {
      favourite = !favourite;
      notifyListeners();
      rethrow;
    }
  }
}
