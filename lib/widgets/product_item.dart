import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../provider/product.dart';
import 'badge.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);
    // Cart_Provider cart = Provider.of<Cart_Provider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsScreen.routName,
          arguments: product.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Lato'),
            ),
            leading: Consumer<Product>(builder: (ctx, product, _) {
              return IconButton(
                icon: Icon(
                  product.favourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  product.toggleFavourite();
                  print("Favourite Pressed");
                },
              );
            }),
            trailing: Consumer<Cart_Provider>(
              builder: (ctx, cart, _) {
                return cart.indexCount(product.id) == 0
                    ? IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          cart.addToCart(
                              product.id, product.title, product.price);
                          print("Cart Pressed");
                        },
                      )
                    : Badge(
                      color: Colors.yellow,
                        value: cart.indexCount(product.id).toString(),
                        child: IconButton(
                          onPressed: () {
                            cart.addToCart(
                                product.id, product.title, product.price);
                            print("Cart Pressed");
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      );
              },
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
