
import 'package:flutter/widgets.dart';

class Product with ChangeNotifier{
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
    this.favourite=false,
  });

  void toggleFavourite(){
    favourite=!favourite;
    notifyListeners();
  }
}