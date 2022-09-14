import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../provider/Order_provider.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart_Provider>(context);
    final order = Provider.of<Order_Provider>(context,listen: false);
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
                          "\$${cart.totalAmount}",
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
                      onPressed: () {
                        if(cart.itemCount>0){
                          order.addOrder(cart.valuesList, cart.totalAmount);
                          cart.clean();
                        }
                      },
                      child: Text(
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
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: 
              (ctx,index)=>CartItem(cart.keyList[index],cart.valuesList[index])
              ),
          ) 
        )
      ]),
    );
  }
}
