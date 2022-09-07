import 'package:flutter/material.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../widgets/item_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  List<Product> loadedProducts=DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop"),
      actions: [
        PopupMenuButton(
          // icon: ,
          onSelected: (value) {
            print(value);
          },
          itemBuilder: (_) =>[
            PopupMenuItem(child: Text("All"),value: 0,),
            PopupMenuItem(child: Text("Favourites"),value: 1,),
          ]
        )
      ],
      ),


      body: ItemGrid(),
       floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
    );
  }
}

