import 'dart:convert';

import 'package:bana_care/models/prduect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class details extends StatefulWidget {
  const details({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<details> createState() => _detailsState();
}

Color textcolor = Colors.black;
Color bordercolor = const Color(0xffBF6F40);
Color ptextcolor = Colors.black;
Color pbordercolor = const Color(0xffBF6F40);
Color color = Colors.black;

class _detailsState extends State<details> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: widget.product.id,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          '$baseip${widget.product.image}',
                        ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  height: 25.h,
                  width: 88.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$',
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.brown),
                        ),
                        Text(
                          (widget.product.discountedPrice * count).toString(),
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(10.w, 4.4.h)),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(5.w, 4.h)),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffBF6F40)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: bordercolor))),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(textcolor),
                            ),
                            onPressed: () {
                              count = count - 1;
                              setState(() {
                                if (count < 1) {
                                  count = 1;
                                } else
                                  count = count;
                                bordercolor = const Color(0xffBF6F40);
                                textcolor = Colors.white;
                              });
                              Future.delayed(const Duration(milliseconds: 350),
                                  () {
                                setState(() {
                                  textcolor = Colors.black;
                                  //   bordercolor = const Color(0xffDEDEDE);
                                });
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              size: 17.sp,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            count.toString(),
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(10.w, 4.4.h)),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(2.w, 3.h)),
                            overlayColor: MaterialStateProperty.all<Color>(
                                const Color(0xffBF6F40)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: pbordercolor))),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(ptextcolor),
                          ),
                          onPressed: () {
                            setState(() {
                              count = count + 1;
                              pbordercolor = const Color(0xffBF6F40);
                              ptextcolor = Colors.white;
                            });
                            Future.delayed(const Duration(milliseconds: 350),
                                () {
                              setState(() {
                                ptextcolor = Colors.black;
                                //   bordercolor = const Color(0xffDEDEDE);
                              });
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: 17.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Text(
                  widget.product.description,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17.sp,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: bordercolor))),
          overlayColor:
              MaterialStateProperty.all<Color>(const Color(0xffBF6F40)),
          foregroundColor: MaterialStateProperty.all<Color>(color),
        ),
        onPressed: () async {
          var uuid = Uuid();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String id = (prefs.getString('id') ?? uuid.v4());
          await prefs.setString('id', id);
          var client = http.Client();
          try {
            var url = Uri.parse('$baseip/api/order/add-to-cart/$id');
            var response = await http.post(url,
                body: jsonEncode(
                    {"product_id": widget.product.id, "qty": count}));
            print(response.statusCode);
            if (response.statusCode == 200) {
              showToast('Product has been successfully added to cart',
                  position: ToastPosition.bottom,
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(color: Colors.black, fontSize: 16.sp),
                  margin: EdgeInsets.only(bottom: 9.h),
                  duration: Duration(seconds: 4));
            }
          } finally {
            client.close();
          }
          setState(() {
            color = Colors.white;
          });
          Future.delayed(const Duration(milliseconds: 350), () {
            setState(() {
              color = Colors.black;
            });
          });
        },
        icon: Icon(
          Icons.shopping_cart_outlined,
          size: 18.sp,
        ),
        label: Text(
          'Add to cart',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
