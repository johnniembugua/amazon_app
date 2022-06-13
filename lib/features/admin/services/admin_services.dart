import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('johnmbugua', 'g0vu2xec');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls,
      );

      http.Response res = await http.post(
        Uri.parse("$uri/admin/add-product"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(text: 'Product added successfully');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(text: e.toString());
      debugPrint(e.toString());
    }
  }

  // get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/admin/get-products"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(text: e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse("$uri/admin/delete-product"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
          {
            'id': product.id,
          },
        ),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(text: e.toString());
    }
  }
}
