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
      confirmDismiss: ((direction) {
        return showDialog(
          context: context, 
          builder: (ctx){
            return AlertDialog(
              title:const Text("Are you sure?"),
              content:const Text("Do you want to delete the cart item?"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(ctx).pop(true);
                }, child:const Text("Yes")),
                TextButton(onPressed: (){
                  Navigator.of(ctx).pop(false);
                }, child:const Text("No"))
              ],
            );
          }
          );
      }),
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