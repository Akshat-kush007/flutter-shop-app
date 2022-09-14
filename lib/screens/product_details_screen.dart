

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/provider/product.dart';

import '../provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static final routName = '/product-details';

  late Product product;
  void setProduct(BuildContext context) {
    final Id = ModalRoute.of(context)!.settings.arguments as String;
    //Turn Off the listener-------------------------------------------
    product =
        Provider.of<Product_Provider>(context, listen: false).findById(Id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setProduct(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 14,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product.imageUrl,
                      height: size.height * 0.35,
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Card(child:Container(width: size.width,
                  child: Text(product.description,style: TextStyle(fontSize: 16),softWrap: true,)),),
                ),
                SizedBox(height: 10,),
                Chip(label: Text("\$${product.price}",style: TextStyle(color: Colors.lightGreen,fontSize: 20,fontWeight: FontWeight.bold),),backgroundColor: Colors.white,)

            ],
          ),
        ));
  }
}
