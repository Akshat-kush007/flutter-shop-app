import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Order_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Product_Provider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart_Provider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order_Provider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData(
            primarySwatch: mycolor,
            accentColor: Colors.lightGreenAccent,
            canvasColor: Colors.grey[300],
            fontFamily: 'Lato'),
        // home: ProductScreen(),
        routes: {
          '/': (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
          CartScreen.routName: (ctx) =>CartScreen(),
          OrderScreen.routName: (ctx) =>OrderScreen(),
        },
      ),
    );
  }
}
