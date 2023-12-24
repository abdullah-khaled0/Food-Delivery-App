import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';


class CartCounter extends StatefulWidget {
  const CartCounter({Key? key}) : super(key: key);


  @override
  _CartCounterState createState() => _CartCounterState();
}

var numOfItems = 1;

class _CartCounterState extends State<CartCounter> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: buildOutlineButton(
            icon: Icons.remove,
            press: () {
              if (numOfItems > 1) {
                setState(() {
                  numOfItems--;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: const TextStyle(
              color: Colors.black38,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: AppColors.mainColor
          ),
          child: buildOutlineButton(
              icon: Icons.add,
              press: () {
                setState(() {
                  numOfItems++;
                });
              }),
        ),
      ],
    );
  }

  SizedBox buildOutlineButton({required IconData icon, required void Function() press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}




class AddToCart extends StatelessWidget {
  const AddToCart({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 20),
          height: 250,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              color: AppColors.yellowColor,
              onPressed: () {},
              child: Text(
                "Buy Now".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
        ),
      ],
    );
  }
}