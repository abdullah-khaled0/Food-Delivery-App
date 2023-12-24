import 'package:flutter/material.dart';
import 'add_to_cart.dart';


class CounterWithFavBtn extends StatelessWidget {
  const CounterWithFavBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CartCounter(),
          Padding(
            padding: EdgeInsets.only(left:30.0),
            child: AddToCart(),
          )
        ],
      ),
    );
  }
}