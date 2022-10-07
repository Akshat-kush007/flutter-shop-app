import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class auth_Provider with ChangeNotifier {
  String? _token ;
  String? _userId;
  DateTime?_expireTime;

   bool get auth {
    return _Token!=null;
  }

  String? get _Token{

    if(_token!= null &&
     _expireTime != null &&
     _expireTime!.isAfter(DateTime.now())){
     return _token!; 
    }
    return null;
  }

  Future signup(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCEk9t6bKmhEhmEKbcS9MFtFWpHlikQ938");
    try {
      final responce = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final decodedResponce = jsonDecode(responce.body);
      // print(decodedResponce);
      if (decodedResponce['error'] != null) {
        throw HttpException(decodedResponce['error']['message']);
      }

      //if succeded
      _userId=decodedResponce["localId"];
      _token=decodedResponce['idToken'];
      _expireTime=DateTime.now().add(Duration(seconds: int.parse(decodedResponce['expiresIn'])));
      notifyListeners();

    } catch (err) {
      rethrow;
    }
  }

  Future login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCEk9t6bKmhEhmEKbcS9MFtFWpHlikQ938");
    try {
      final responce = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final decodedResponce = jsonDecode(responce.body);
      // print(decodedResponce);
      if (decodedResponce['error'] != null) {
        throw HttpException(decodedResponce['error']['message']);
      }

      //if succeded
      _userId=decodedResponce["localId"];
      _token=decodedResponce['idToken'];
      _expireTime=DateTime.now().add(Duration(seconds: int.parse(decodedResponce['expiresIn'])));
      
      notifyListeners();

    } catch (err) {
      rethrow;
    }
  }
}
