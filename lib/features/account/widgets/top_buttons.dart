import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  TopButtons({Key? key}) : super(key: key);

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Your Orders', onTap: () {}),
            AccountButton(text: 'Turn Seller', onTap: () {}),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
                text: 'Logout', onTap: () => AccountServices().logOut(context)),
            AccountButton(text: 'Your Wishlist', onTap: () {}),
          ],
        ),
      ],
    );
  }
}
