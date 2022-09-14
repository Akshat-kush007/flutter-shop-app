import 'package:flutter/material.dart';
import 'package:shop_app/screens/order_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Text("Shop App",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                )),
          ),
              
          ],) ,
        ),
        ListTile(
          title: Text("Shop",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.shop),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          title: Text("Orders",style: TextStyle(fontSize: 20),),
          trailing: Icon(Icons.move_up_outlined),
          onTap: (){
             
            Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
          },
        )
        ],
      ),
    );
  }
}