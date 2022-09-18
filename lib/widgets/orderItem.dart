import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/Order_provider.dart';

class OrderItem extends StatefulWidget {
  final OrderData order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItem> {
  bool _expands = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(children: [
        ListTile(
          title: Text("\$${widget.order.total}"),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _expands = !_expands;
              });
            },
            icon: Icon(_expands ? Icons.expand_less : Icons.expand_more),
          ),
        ),
        if (_expands) Divider(indent: 10,endIndent: 10,),
        if (_expands)
          Container(
            height: min(30 + widget.order.cartItems.length * 30.0, 200),
            child: ListView(
              children: widget.order.cartItems.map((cart) {
                return ListTile(
                  leading: Chip(label: Text("\$${cart.price}")),
                  title: Text(cart.title),
                  subtitle: Text("Total : \$${cart.quantity * cart.price}"),
                  trailing: Chip(label: Text("${cart.quantity} x ")),
                );
              }).toList(),
            ),
          ),
      ]),
    );
  }
}
