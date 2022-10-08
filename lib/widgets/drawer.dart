import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/screens/manage_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';

enum Draweritems{
  shop,
  order,
  manage,
}


class MyDrawer extends StatelessWidget {
  final Draweritems curr;
  MyDrawer(this.curr);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
          height: 200,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.topLeft,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).accentColor
                  ), 
                  icon: const Icon(Icons.arrow_back_ios), 
                  label: const Text("Close"),),
              ],
            ),
         const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text("Shop App",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                )),
          ),
              
          ],) ,
        ),
        ListTile(
          selected: curr==Draweritems.shop,
          selectedColor: Theme.of(context).primaryColor,
           
          title: Text("Shop",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.shop),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          selected: curr==Draweritems.order,
          selectedColor: Theme.of(context).primaryColor,
          title: Text("Orders",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.move_up_outlined),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
          },
        ),
        ListTile(
          selected: curr==Draweritems.manage,
          selectedColor: Theme.of(context).primaryColor,
          title: Text("Manage Product",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.edit),
          onTap: (){ 
            Navigator.of(context).pushReplacementNamed(ManageProductScreen.routName);
          },
        )
        ,
        ListTile(
          selected: curr==Draweritems.manage,
          selectedColor: Theme.of(context).primaryColor,
          title: Text("Logout",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.logout),
          onTap: (){ 
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');

            Provider.of<auth_Provider>(context,listen: false).logOut();
          },
        )
        ],
      ),
    );
  }
}