import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/Order_provider.dart';

class OrderItem extends StatelessWidget {
  final OrderData order;
  OrderItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${order.total}"),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(order.dateTime)),
            trailing: IconButton(onPressed: (){},icon: Icon(Icons.expand_more)),
          )
        ]
        ),
    );
  }
}