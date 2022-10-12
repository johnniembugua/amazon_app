import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../services/admin_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices _adminServices = AdminServices();
  @override
  void initState() {
    fetchAllOrders();
    super.initState();
  }

  fetchAllOrders() async {
    orders = await _adminServices.fetchAllorders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : orders!.isEmpty
            ? const Center(
                child: Text("No Products"),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: orders!.length,
                itemBuilder: (context, index) {
                  final orderData = orders![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, OrderDetailScreen.routename,
                          arguments: orderData);
                    },
                    child: SizedBox(
                      height: 140,
                      child:
                          SingleProduct(img: orderData.products[0].images[0]),
                    ),
                  );
                },
              );
  }
}
