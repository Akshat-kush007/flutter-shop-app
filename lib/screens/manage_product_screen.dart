import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/addEdit_product_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/manageProduct_item.dart';

class ManageProductScreen extends StatelessWidget {
  static const routName = '/manage-product';

  Future _refresh(BuildContext context) async {
    return await Provider.of<Product_Provider>(context, listen: false)
        .refreshProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products_provider_object=Provider.of<Product_Provider>(context);
    // final products=products_provider_object.list;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Product"),
        actions: [
          IconButton(
              onPressed: () {
                _refresh(context);
              },
              icon: const Icon(Icons.loop_outlined)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddEditProductScreen.routName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: MyDrawer(Draweritems.manage),
      body: FutureBuilder(
          future: _refresh(context),
          builder: ((context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Product_Provider>(
                      builder: (context, products, child) {
                        return ListView.builder(
                            itemCount: products.list.length,
                            itemBuilder: (ctx, index) {
                              return ManageProductItem(products.list[index]);
                            });
                      },
                    ));
          })),
    );
  }
}
