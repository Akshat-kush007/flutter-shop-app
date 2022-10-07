import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routName = '/addEdit-product-screen';
  // Product? _existingProduct=null;
  // AddEditProductScreen(this._existingProduct);
  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  // Product_Provider product_provider_object=Provider(create: create)
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String id = "";
  String title = "";
  String price = "";
  String description = "";
  String imageUrl = "";
  bool favourite = false;

  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final _existingProduct =
        ModalRoute.of(context)?.settings.arguments as Product?;
    if (_existingProduct != null) {
      // print(_existingProduct.title);
      id = _existingProduct.id;
      title = _existingProduct.title;
      price = _existingProduct.price.toString();
      description = _existingProduct.description;
      favourite = _existingProduct.favourite;
      imageUrl = _existingProduct.imageUrl;
      _imageTextEditingController.text = imageUrl;
    }
    print("id: ${id}");
    print("title: ${title}");
    print("price: ${price}");
    print("description: ${description}");
    print("ImageUrl: ${imageUrl}");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageTextEditingController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _onSave() async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      print("id: ${id}");
      print("title: ${title}");
      print("price: ${price}");
      print("description: ${description}");
      print("ImageUrl: ${imageUrl}");
      if (id == "") {
        Product product = Product(
          id: DateTime.now().toString(),
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: double.parse(price),
          favourite: favourite,
        );

        try {
          await Provider.of<Product_Provider>(context, listen: false)
              .addProduct(product);
        } catch (error) {
          await showDialog(
            context: context,
            builder: ((ctx) {
              return AlertDialog(
                title: const Text(
                  "ERROR",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("Something went wrong!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(Future.value());
                      },
                      child: Text("Okay"))
                ],
              );
            }),
          );
        }
      } else {
        Product product = Product(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: double.parse(price),
          favourite: favourite,
        );
        try {
          await Provider.of<Product_Provider>(context, listen: false)
              .updateProduct(product);
        } catch (_) {
          await showDialog(
            context: context,
            builder: ((ctx) {
              return AlertDialog(
                title: const Text(
                  "ERROR",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text("Something went wrong!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(Future.value());
                      },
                      child: Text("Okay"))
                ],
              );
            }),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _onSave,
            icon: const Icon(Icons.save_alt_sharp),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: const InputDecoration(label: Text("Title")),
                        initialValue: title,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          title = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a Title";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        focusNode: _priceFocusNode,
                        decoration: const InputDecoration(label: Text("Price")),
                        initialValue: price,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          price = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a price";
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return "Enter a valid price";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        focusNode: _descFocusNode,
                        decoration:
                            const InputDecoration(label: Text("Description")),
                        initialValue: description,
                        maxLines: 3,
                        // textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          description = value!;
                        },
                        // validator: (value) {
                        //   if (value!.isEmpty || value.length < 10) {
                        //     return "Enter a Description of atleast 10 char";
                        //   }

                        //   return null;
                        // },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, right: 6),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageTextEditingController.text.isEmpty
                                ? const Center(
                                    child: Text("Enter Url"),
                                  )
                                : Image.network(
                                    _imageTextEditingController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: _imageTextEditingController,
                            focusNode: _imageUrlFocusNode,
                            decoration:
                                const InputDecoration(label: Text("Image Url")),
                            // initialValue: imageUrl,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onSaved: (value) {
                              imageUrl = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a ImageUrl";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "Enter a valid URL";
                              }
                              return null;
                            },
                            // onEditingComplete: () {
                            //   setState(() {

                            //   });
                            // },
                          ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            onPressed: _onSave,
                            icon: Icon(Icons.save_alt),
                            label: Text("Save")),
                      )
                    ],
                  )),
            ),
    );
  }
}
