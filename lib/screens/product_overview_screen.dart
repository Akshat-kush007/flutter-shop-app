import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../provider/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/item_grid.dart';
import 'cart_screen.dart';

enum Prefrence {
  All,
  Favourites,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName="/product-overview";

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isLoading=true;
  @override
  void initState() {
    //fetching product in product_provider
     Provider.of<Product_Provider>(context,listen: false)
     .featchAndSetProducts()
     .then((_) {
      
     })
     .catchError((err){
        return showDialog(
          context: context, 
          builder:((context) {
            return AlertDialog(
              title: Text("This Error !"),
              content: Text(err.toString()),
              actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Okay"))],
            );
          }) 
        );
     }).whenComplete((){
        setState(() {
        isLoading=false;
      });
     });
  
    super.initState();
  }
  @override
  void didChangeDependencies() {
      
    super.didChangeDependencies();
  }

  @override
  bool _showFavourites = false;
  Widget build(BuildContext context) {
    final product_provider_object = Provider.of<Product_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        actions: [
          Consumer<Cart_Provider>(
            builder: (ctx, cart, ch) {
              return Badge(
                child: ch!,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
              // icon: ,
              onSelected: (Prefrence value) {
                setState(() {
                  if (value == Prefrence.Favourites) {
                    _showFavourites = true;
                  } else {
                    _showFavourites = false;
                  }
                });
              },
              itemBuilder: (_) => const [
                    //here value can ba an integer-
                    //But, we using enum because enum is name assigned to integer value.
                    PopupMenuItem(
                      value: Prefrence.All,
                      child: Text("All"),
                    ),
                    PopupMenuItem(
                      value: Prefrence.Favourites,
                      child: Text("Favourites"),
                    ),
                  ])
        ],
      ),
      drawer: MyDrawer(Draweritems.shop),
      body: isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : ItemGrid(_showFavourites),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
