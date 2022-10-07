import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../provider/Order_provider.dart';

class CartScreen extends StatefulWidget {
  static const routName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart_Provider>(context);
    final order = Provider.of<Order_Provider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: FittedBox(
                    child: Row(
                      children: [
                        Text(
                          "Total Amount : ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "\$" + cart.totalAmount.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: (cart.itemCount <= 0 || isLoading)
                          ? null
                          : () {
                              if (cart.itemCount > 0) {
                                setState(() {
                                  isLoading = true;
                                });

                                order
                                    .addOrder(cart.valuesList, cart.totalAmount)
                                    .then((value) {
                                  cart.clean();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Order Successfully added!",textAlign: TextAlign.center,)));
                                }).catchError((err) async {
                                  await showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            "ERROR !",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: Text(
                                              "The [style] argument is optional. When omitted, the text will use the style from the closest enclosing [DefaultTextStyle]. If the given style's [TextStyle.inherit] property is true (the default), the given style will be merged with the closest enclosing [DefaultTextStyle]."),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Okay"))
                                          ],
                                        );
                                      });
                                }).whenComplete(() {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "ORDER NOW",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                    )),
              ],
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) =>
                  CartItem(cart.keyList[index], cart.valuesList[index])),
        ))
      ]),
    );
  }
}
