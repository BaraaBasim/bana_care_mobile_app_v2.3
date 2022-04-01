import 'package:bana_care/assets/Colors/maincolors.dart';
import 'package:bana_care/models/prduect.dart';
import 'package:bana_care/models/prodeuctreq.dart';
import 'package:bana_care/widgets/productcard.dart';
import 'package:bana_care/widgets/shamer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';

class catagierl extends StatelessWidget {
  const catagierl({
    Key? key,
    required this.tag,
    required this.name,
  }) : super(key: key);
  final String tag;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Hero(
            tag: tag,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                name,
                style: TextStyle(fontSize: 20.sp, color: maincolor),
              ),
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        child: FutureBuilder<List<Product>>(
          future: fetchListproduects('$baseip/api/products?Categorys=$tag'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product>? data = snapshot.data;
              return listproduects(
                data: data,
              );
            } else if (snapshot.hasError) {
              return shamer();
            }
            return shamer();
          },
        ),
      ),
    );
  }
}

class listproduects extends StatelessWidget {
  const listproduects({
    Key? key,
    required this.data,
  }) : super(key: key);
  final List<Product>? data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: List.generate(data!.length, (int index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ProductCard(
            product: data![index],
            id: data![index].id,
            title: data![index].name,
            caver: data![index].image,
            price: data![index].discountedPrice.toString(),
            width: 100.w,
          ),
        );
      }),
    );
  }
}
