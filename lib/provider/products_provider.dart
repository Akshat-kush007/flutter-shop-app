import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/provider/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product_Provider with ChangeNotifier {
  List<Product> _priveteList = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red! ',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  bool isInit = true;
  // 
  // 
  Future<void> featchAndSetProducts() async {
    if (isInit) {
      final url = Uri.parse(
          "https://shop-app-53863-default-rtdb.firebaseio.com/products.json");
      try{
          final responce = await http.get(url);
          print(responce.body);
          final eMap = jsonDecode(responce.body) as Map<String, dynamic>;
      eMap.forEach((prodId, prodData) {
        final pro = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['url'],
            price: prodData['price'],
            favourite: prodData['favourite']);
        _priveteList.insert(0, pro);
      });
      notifyListeners();
      isInit = false;


      }catch(err){
        rethrow;
      }
      
    }
  }

  Future<void> refreshProducts() async {
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/products.json");
    final responce = await http.get(url);
    final eMap = jsonDecode(responce.body) as Map<String, dynamic>;
    List<Product> newList = [];
    eMap.forEach((prodId, prodData) {
      final pro = Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        imageUrl: prodData['url'],
        price: prodData['price'],
        favourite: prodData['favourite'],
      );
      newList.insert(0, pro);
    });
    _priveteList = newList;
    print(jsonDecode(responce.body));
    notifyListeners();
  }

  List<Product> get list {
    return [..._priveteList];
  }

  int get productCount {
    return _priveteList.length;
  }

  List<Product> get favouriteOnlyList {
    return _priveteList.where((element) => element.favourite).toList();
  }

  //Methods to update this provider
  Future addProduct(Product product) {
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/products.json");
    return http
        .post(url,
            body: jsonEncode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'url': product.imageUrl,
              "favourite": product.favourite
            }))
        .then((response) {
      final pro = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        favourite: product.favourite,
      );

      _priveteList.insert(0, pro);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/products/${product.id}");
    Response res = await http.patch(url,
        body: jsonEncode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'url': product.imageUrl,
        }));
    if (res.statusCode >= 400) {
      print("update Error ");
      throw HttpException("Update Error!");
    }
    int index = _priveteList.indexWhere((element) => element.id == product.id);
    _priveteList[index] = product;
    notifyListeners();
  }

  Product findById(String Id) {
    return _priveteList.firstWhere((element) => element.id == Id);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-53863-default-rtdb.firebaseio.com/products/$id.json");
    final existingIndex =
        _priveteList.indexWhere((element) => element.id == id);
    Product? tempProduct = _priveteList[existingIndex];
    _priveteList.removeWhere((element) => element.id == id);
    notifyListeners();

    try {
      Response responce = await http.delete(url);
      if (responce.statusCode >= 400) {
        _priveteList.insert(existingIndex, tempProduct);
        notifyListeners();
        throw (HttpException("Could not able to delete"));
      } else {
        tempProduct = null;
      }
    } catch (err) {
      rethrow;
    }
  }
}
