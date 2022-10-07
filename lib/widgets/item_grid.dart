import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/product_item.dart';

class ItemGrid extends StatelessWidget {
  final _showFavourites;
  ItemGrid(this._showFavourites);
  @override
  Widget build(BuildContext context) {

    //Access data to above registered provider
    final product_provider_object=Provider.of<Product_Provider>(context);
    final loadedProducts= _showFavourites ? product_provider_object.favouriteOnlyList : product_provider_object.list;
    return (loadedProducts.isEmpty) 
    ? const Center(child : Text("No Products \nFound !")) 
    : GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
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