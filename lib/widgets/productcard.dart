import 'package:bana_care/assets/Colors/maincolors.dart';
import 'package:bana_care/models/prduect.dart';
import 'package:bana_care/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.width,
    required this.id,
    required this.product,
    required this.price,
    this.title = 'Package 1',
    required this.caver,
  }) : super(key: key);
  final double width;
  final String price, title, caver, id;
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

Color bordercolor = Colors.white;

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    String tag = widget.id;
    return InkWell(
      onTap: () {
        setState(() {
          bordercolor = maincolor;
        });
        Future.delayed(const Duration(milliseconds: 350), () {
          setState(() {
            bordercolor = Colors.white;
          });
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => details(
                    product: widget.product,
                  )),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: bordercolor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: widget.width,
        child: Column(
          children: [
            Hero(
              tag: tag,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        '$baseip${widget.caver}',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                height: 17.h,
                width: widget.width,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$',
                        style: TextStyle(fontSize: 18.sp, color: Colors.brown),
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
