import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/provider/product.dart';

import '../provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static final routName='/product-details';

  late Product product;
  void setProduct(BuildContext context){
    final Id=ModalRoute.of(context)!.settings.arguments as String;
    product=Provider.of<Product_Provider>(
      context,
      //Turn Off the listener-------------------------------------------
      listen: false,
      ).findById(Id);
  }

  
  @override
  Widget build(BuildContext context) {
    setProduct(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );  
  }
}