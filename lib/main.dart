import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Order_provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/screens/addEdit_product_screen.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/manage_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../screens/product_details_screen.dart';
import '../screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  MaterialColor mycolor = MaterialColor(
    Color.fromRGBO(255, 255, 0, 1).value,
    <int, Color>{
      50: Color.fromRGBO(255, 255, 0, 0.1),
      100: Color.fromRGBO(255, 255, 0, 0.2),
      200: Color.fromRGBO(255, 255, 0, 0.3),
      300: Color.fromRGBO(255, 255, 0, 0.4),
      400: Color.fromRGBO(255, 255, 0, 0.5),
      500: Color.fromRGBO(255, 255, 0, 0.6),
      600: Color.fromRGBO(255, 255, 0, 0.7),
      700: Color.fromRGBO(255, 255, 0, 0.8),
      800: Color.fromRGBO(255, 255, 0, 0.9),
      900: Color.fromRGBO(255, 255, 0, 1),
    },
  );
  @override
  Widget build(BuildContext context) {
    print("Build main\n\n");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => auth_Provider(),
          ),
          ChangeNotifierProxyProvider<auth_Provider, Product_Provider>(
              create: (_) => Product_Provider(),
              update: (_, auth, products) {
                products!.authToken = auth.Token;
                products.userId = auth.UserId;
                return products;
              }),
          ChangeNotifierProvider(
            create: (ctx) => Cart_Provider(),
          ),
          ChangeNotifierProxyProvider<auth_Provider, Order_Provider>(
              create: (_) => Order_Provider(),
              update: (_, auth, orders) {
                orders!.authToken = auth.Token;
                orders.userId = auth.UserId;
                return orders;
              }),
        ],
        child: Consumer<auth_Provider>(
          
          builder: ((context, authObject, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shop App',
                theme: ThemeData(
                    primarySwatch: mycolor,
                    accentColor: Colors.lightGreenAccent,
                    canvasColor: Colors.grey[300],
                    fontFamily: 'Lato'),


                home: authObject.auth
                    ? ProductOverviewScreen()
                    : FutureBuilder(
                        future: authObject.tryAutoLogIn(),
                        builder: ((context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen();
                        }),
                      ),

                      
                routes: {
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                  ProductOverviewScreen.routeName: (ctx) =>
                      ProductOverviewScreen(),
                  ProductDetailsScreen.routName: (ctx) =>
                      ProductDetailsScreen(),
                  CartScreen.routName: (ctx) => CartScreen(),
                  OrderScreen.routName: (ctx) => OrderScreen(),
                  ManageProductScreen.routName: (ctx) => ManageProductScreen(),
                  AddEditProductScreen.routName: (ctx) =>
                      AddEditProductScreen(),
                },
              )),
        ));
  }
}
