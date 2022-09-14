import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String productId; 
  final CartData cart;
  CartItem(this.productId,this.cart);

  

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        child: Icon(Icons.delete,color: Colors.white,),
        ),
      onDismissed: (direction){
        Provider.of<Cart_Provider>(context, listen: false).deleteItem(productId);
      },
      child: Card(
        child: ListTile(
          leading: Chip(label: Text("\$${cart.price}")),
          title: Text(cart.title),
          subtitle: Text("Total : \$${cart.quantity*cart.price}"),
          trailing: Chip(label: Text("${cart.quantity} x ")),
        ),
      ),
    );
  }
}