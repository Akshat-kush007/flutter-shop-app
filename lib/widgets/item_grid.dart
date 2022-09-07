import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/product_item.dart';

class ItemGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Access data to above registered provider
    final product_provider_object=Provider.of<Product_Provider>(context);
    final loadedProducts=product_provider_object.list;
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,        
        ) ,
      itemCount: loadedProducts.length,
      itemBuilder: (ctx,index){
        //Registering Provider for each of the item.
        return ChangeNotifierProvider.value(

          value: loadedProducts[index],
          child: ProductItem());
      }
     );
  }
}