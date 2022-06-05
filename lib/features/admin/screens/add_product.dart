import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  String category = 'Mobiles';
  List<File> images = [];
  void selectImages() async {
    var res = await pickImages();

    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            "Add Product",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Form(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: selectImages,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.folder_open,
                          size: 40,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Select Product Images",
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 30),
            CustomTextField(
                controller: productNameController, hintText: "Product Name"),
            const SizedBox(height: 10),
            CustomTextField(
              controller: descriptionController,
              hintText: "Description",
              maxlines: 7,
            ),
            const SizedBox(height: 10),
            CustomTextField(controller: priceController, hintText: "Price"),
            const SizedBox(height: 10),
            CustomTextField(
                controller: quantityController, hintText: "Quantity"),
            SizedBox(
                width: double.infinity,
                child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    })),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Sell',
              onTap: () {},
            ),
          ],
        ),
      ))),
    );
  }
}
