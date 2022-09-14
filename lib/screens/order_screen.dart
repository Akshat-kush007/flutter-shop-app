import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Order_provider.dart';
import 'package:shop_app/widgets/orderItem.dart';

class OrderScreen extends StatelessWidget {
  static const routName='/order-screen';
  @override
  Widget build(BuildContext context) {
    final order=Provider.of<Order_Provider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: ListView.builder(
        itemCount: order.itemCount,
        itemBuilder: ((context, index) {
        return OrderItem(order.items[index]);
      })),
    );
  }
}