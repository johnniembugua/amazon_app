import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';

class Orders extends StatefulWidget {
  Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;

  final AccountServices accountServices = AccountServices();
  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  fetchOrders() async {
    orders = await accountServices.fetchMyOrders(
      context: context,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : orders!.isEmpty
            ? const Center(
                child: Text("No Previous Orders available"),
              )
            : Column(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: Text(
                          "See all",
                          style: TextStyle(
                              color: GlobalVariables.selectedNavBarColor),
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
                        itemCount: orders!.length,
                        itemBuilder: ((context, index) {
                          print(orders!.length.toString());
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              OrderDetailScreen.routename,
                              arguments: orders![index],
                            ),
                            child: SingleProduct(
                                img: orders![index].products[0].images[0]),
                          );
                        })),
                  )
                ],
              );
  }
}
