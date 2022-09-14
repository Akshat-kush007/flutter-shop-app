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
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
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
      drawer: MyDrawer(),
      body: ItemGrid(_showFavourites),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
