import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/addEdit_product_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/manageProduct_item.dart';

class ManageProductScreen extends StatelessWidget {
  static const routName='/manage-product';

  @override
  Widget build(BuildContext context) {
    final products_provider_object=Provider.of<Product_Provider>(context);
    final products=products_provider_object.list;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Product"),
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(AddEditProductScreen.routName);
            }, icon: const Icon(Icons.add))
          ],
        ),
      drawer: MyDrawer(Draweritems.manage),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx,index){
          return ManageProductItem(products[index]);
      }),
    );
  }
}