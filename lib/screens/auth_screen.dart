import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/provider/auth_provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 234, 117).withOpacity(0.5),
                  Color.fromARGB(255, 153, 253, 106).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal:  deviceSize.width*0.2),
                      transform: Matrix4.rotationZ(-6 * pi / 180)
                        ..translate(-5.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 251, 255, 12),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black54,
                            // offset: Offset(2, 1),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          // color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  // const AuthCard({
  //    Key key,
  // }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  Future _dialoge(String message){
    return showDialog(
      context: context, 
      builder: ((context) {
        return AlertDialog(
          title: Text("Error!"),
          content: Text(message),
          actions: [TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Okay'))],
        );
      })
    );
  }
  void _submit() async{
    
      if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    
    setState(() {
      _isLoading = true;
    });
    print("Email : ${_authData['email']}");
    print("Password : ${_authData['password']}");
    try{
        if (_authMode == AuthMode.Login) {
        // LogIn user in
        await Provider.of<auth_Provider>(context,listen: false).login(_authData['email']!, _authData['password']!);
      } else {
        // SignIn user in
        await Provider.of<auth_Provider>(context,listen: false).signup(_authData['email']!, _authData['password']!);
      }
    }on HttpException catch(err){
      await _dialoge(err.toString());
    }catch(err){
      await _dialoge("Something went wrong!\nPlease try again later.");

    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? deviceSize.height * 0.65: deviceSize.height * 0.45,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      child:
                          Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      onSurface: Theme.of(context).primaryColor,
                      onPrimary: Theme.of(context).primaryTextTheme.button!.color,
                    
                      ),
                      ),
                  TextButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      primary: Theme.of(context).primaryColor,

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
