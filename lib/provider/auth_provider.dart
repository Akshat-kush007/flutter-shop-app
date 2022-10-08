import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class auth_Provider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expireTime;
  Timer? _authTimer;

  bool get auth {
    return Token != null;
  }

  String? get Token {
    if (_token != null &&
        _expireTime != null &&
        _expireTime!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get UserId {
    return _userId;
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
      _userId = decodedResponce["localId"];
      _token = decodedResponce['idToken'];
      _expireTime = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponce['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'userId': _userId,
        'token': _token,
        'expireTime': _expireTime!.toIso8601String(),
      });
      prefs.setString('loginInfo', userData);
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
      _userId = decodedResponce["localId"];
      _token = decodedResponce['idToken'];
      _expireTime = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponce['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode({
        'userId': _userId,
        'token': _token,
        'expireTime': _expireTime!.toIso8601String(),
      });
      prefs.setString('loginInfo', userData);
    } catch (err) {
      rethrow;
    }
  }

 

  Future<bool> tryAutoLogIn() async {
    print("tryAutoLogIn");
    try{
    final prefs = await SharedPreferences.getInstance();
    // print("i have reached here");
    if (!prefs.containsKey('loginInfo')) {
      print("not able");
      return false;
    }
    final userData = jsonDecode(prefs.getString("loginInfo")!);
    // print(userData);
    DateTime expireTime = DateTime.parse(userData['expireTime']);
    if (expireTime.isBefore(DateTime.now())) {
      print("not able");
      return false;
    }

      print("Auto login succed");
      // print("i have reached here");
    _userId = userData['userId'];
    _token = userData['token'];
    _expireTime = expireTime;

    notifyListeners();
    _autoLogout();
    return true;
    }catch(err){
      print(err);
      rethrow;
    }
      
  }


 void logOut() async{
    print("Logout!!");
    _token = null;
    _expireTime = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('loginInfo')) {
      print("Deleting shared prefrences");
      prefs.remove('loginInfo');
    }
    notifyListeners();
  }

  void _autoLogout() {
    print("autoLogout!!");
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire =_expireTime!.difference(DateTime.now()) ;
    print(timeToExpire.toString());
    _authTimer = Timer(timeToExpire, logOut);
  }
}
