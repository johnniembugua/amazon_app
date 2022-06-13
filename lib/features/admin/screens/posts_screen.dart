import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products;
  final AdminServices _adminServices = AdminServices();
  @override
  void initState() {
    fetchAllProducts();
    super.initState();
  }

  fetchAllProducts() async {
    products = await _adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) async {
    _adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          products!.removeAt(index);
          showSnackBar(text: "${product.name} deleted successfully");
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products == null
          ? const Loader()
          : GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                print(products!.length);
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(img: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: Text(
                          productData.name,
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        IconButton(
                            onPressed: () => deleteProduct(productData, index),
                            icon: const Icon(Icons.delete_outline))
                      ],
                    )
                  ],
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        tooltip: "Add a Product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
