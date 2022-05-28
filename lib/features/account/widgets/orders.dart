import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //manual list

  List list = [
    {
      "name": "Order 1",
      "date": "12/12/2020",
      "status": "Pending",
      "price": "\$100",
      "image":
          "https://images.unsplash.com/photo-1651407825801-eec2dcbd86bd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTd8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    },
    {
      "name": "Order 2",
      "date": "12/12/2020",
      "status": "Pending",
      "price": "\$100",
      "image":
          "https://images.unsplash.com/photo-1651440204296-a79fa9988007?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60",
    },
    {
      "name": "Order 2",
      "date": "12/12/2020",
      "status": "Pending",
      "price": "\$100",
      "image":
          "https://images.unsplash.com/photo-1651454060241-a218f790be13?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MTF8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    },
    {
      "name": "Order 2",
      "date": "12/12/2020",
      "status": "Pending",
      "price": "\$100",
      "image":
          "https://images.unsplash.com/photo-1616696695535-98369e260e7a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                "Your Orders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                "See all",
                style: TextStyle(color: GlobalVariables.selectedNavBarColor),
              ),
            ),
          ],
        ),
        //display orders here

        Container(
          height: 170,
          padding: const EdgeInsets.only(
            left: 10,
            right: 0,
            top: 20,
          ),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: ((context, index) {
                return SingleProduct(img: list[index]['image']);
              })),
        )
      ],
    );
  }
}
