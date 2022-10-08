import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/provider/Order_provider.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/orderItem.dart';

class OrderScreen extends StatelessWidget {
  static const routName = '/order-screen';
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(title: Text("Orders")),
        drawer: MyDrawer(Draweritems.order),
        body: FutureBuilder(
          future: Provider.of<Order_Provider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                //Error Handling
                return Center(
                  child: Text("No orders yet!"),
                );
              } else {
                return Consumer<Order_Provider>(
                    builder: ((context, orderData, child) {
                  return orderData.itemCount <= 0
                      ? Center(
                          child: Text("No orders yet!"),
                        )
                      : ListView.builder(
                          itemCount: orderData.itemCount,
                          itemBuilder: ((context, index) {
                            return OrderItem(orderData.items[index]);
                          }));
                }));
              }
            }
          }),
        ));
  }
}

// class OrderScreen extends StatefulWidget {
//   static const routName='/order-screen';

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   bool _isLoading=true;
  
//   @override
//   void initState() {
//     Provider.of<Order_Provider>(context,listen: false).fetchAndSetOrders().whenComplete(() {
//       setState(() {
//         _isLoading=false;
//       });
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final order=Provider.of<Order_Provider>(context);
//     // order.fetchAndSetOrders();
//     return Scaffold(
//       appBar: AppBar(title: Text("Orders")),
//       drawer: MyDrawer(Draweritems.order),
//       body: _isLoading
//       ? Center(child: CircularProgressIndicator(),)
//       :  order.itemCount<=0 
//         ? Center(child: Text("No orders yet!"),)
//         : ListView.builder(
//           itemCount: order.itemCount,
//           itemBuilder: ((context, index) {
//           return OrderItem(order.items[index]);
//         })),
//     );
//   }
// }