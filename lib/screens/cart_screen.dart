import 'dart:convert';

import 'package:bana_care/assets/Colors/maincolors.dart';
import 'package:bana_care/models/prduect.dart';
import 'package:bana_care/models/prodeuctreq.dart';
import 'package:bana_care/widgets/shamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

ValueNotifier<int> prices = ValueNotifier<int>(0);
late Future<List<Cart>> futureData;

late Future<List<Cart>> laterData;

class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  _cartState createState() => _cartState();
}

Color textcolor = Colors.black;
Color bordercolor = const Color(0xffBF6F40);
Color ptextcolor = Colors.black;
Color pbordercolor = const Color(0xffBF6F40);
Color color = Colors.black;
int price = 0;

class _cartState extends State<cart> with AutomaticKeepAliveClientMixin {
  List<Cart>? data;

  List<TextEditingController> myController =
      List.generate(3, (i) => TextEditingController());

  void initState() {
    prices = ValueNotifier<int>(0);
    futureData = fetchcart();
    super.initState();
  }

  @override
  void dispose() {
    prices.dispose();
    super.dispose();
  }

  void removeItem(int index) {
    print(data!.length);
    setState(() {
      data!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    laterData = fetchcart();
    if (futureData != laterData) {
      setState(() {
        futureData = laterData;
      });
    }
    return Stack(children: [
      SingleChildScrollView(
        child: SizedBox(
          height: 70.h,
          width: 100.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: FutureBuilder<List<Cart>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    prices.value = price;
                  });
                }
                if (snapshot.hasData && futureData == laterData) {
                  price = 0;
                  data = snapshot.data;

                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: List.generate(data!.length, (int index) {
                      price = data![index].product.discountedPrice *
                              data![index].itemQty +
                          price;
                      return itme(
                          data: data![index],
                          index: index,
                          onDelete: () => removeItem(index),
                          key: ObjectKey(data![index]));
                    }),
                  );
                } else if (snapshot.hasError) {
                  return shamer();
                }
                return shamer();
              },
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          width: 100.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Totel price",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.brown),
                            ),
                            ValueListenableBuilder(
                              valueListenable: prices,
                              builder: (context, value, child) => Text(
                                '$value',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 34.w),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: bordercolor))),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color(0xffBF6F40)),
                    foregroundColor: MaterialStateProperty.all<Color>(color),
                  ),
                  onPressed: () async {
                    if (prices.value != 0) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool getaddress = (prefs.getBool('getaddress') ?? false);
                      if (getaddress == false) {
                        Widget fadeAlertAnimation(
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) {
                          return Align(
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        }

                        Alert(
                          closeIcon: Icon(Icons.close_outlined),
                          alertAnimation: fadeAlertAnimation,
                          context: context,
                          title: "Please add your address",
                          content: Column(
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_circle),
                                  labelText: 'full name',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: maincolor),
                                  ),
                                ),
                                controller: myController[0],
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone_outlined),
                                  labelText: 'Phone number',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: maincolor),
                                  ),
                                ),
                                controller: myController[1],
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.red),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.home_outlined),
                                  labelText: 'Address',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: maincolor),
                                  ),
                                ),
                                controller: myController[2],
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String id = (prefs.getString('id') ?? '');
                                var client = http.Client();
                                try {
                                  var url = Uri.parse('$baseip/api/address');
                                  var response = await http.post(url,
                                      body: jsonEncode({
                                        "uid": id,
                                        "address1": myController[2].text,
                                        'name': myController[0].text,
                                        'phone': myController[1].text,
                                      }));
                                  print(
                                      'Response status: ${response.statusCode}');
                                  print('Response body: ${response.body}');
                                  if (response.statusCode == 201) {
                                    await prefs.setBool('getaddress', true);
                                    Navigator.pop(context);
                                  }
                                } finally {
                                  client.close();
                                }
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              color: maincolor,
                            )
                          ],
                        ).show();
                      } else if (getaddress == true) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? id = (prefs.getString('id'));
                        print('Pressed $id times.');
                        var client = http.Client();
                        print(id);
                        try {
                          var url = Uri.parse('$baseip/api/order/create_order');
                          var response = await http.post(url,
                              body: jsonEncode({"uid": id}));
                          print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');
                          if (response.statusCode == 200) {
                            Alert(
                              context: context,
                              type: AlertType.success,
                              title: "Order state",
                              desc:
                                  "Your order is being processed for shipping.",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "ok",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  width: 120,
                                )
                              ],
                            ).show();
                            setState(() {
                              color = Colors.white;
                            });
                            setState(() {
                              print('ok');

                              futureData = fetchcart();
                            });
                          }
                        } finally {
                          client.close();
                        }
                      }

                      Future.delayed(const Duration(milliseconds: 350), () {
                        setState(() {
                          color = Colors.black;
                        });
                      });
                    }
                  },
                  child: Text(
                    'Order',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class itme extends StatefulWidget {
  const itme({
    Key? key,
    required this.data,
    required this.index,
    required this.onDelete,
  }) : super(key: key);

  @override
  _itmeState createState() => _itmeState();
  final Cart data;
  final int index;
  final VoidCallback onDelete;
}

class _itmeState extends State<itme> {
  int count = 0;

  void initState() {
    count = 0;

    super.initState();
  }

  @override
  void dispose() {
    count = 0;
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    print(count);
    print('---');
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: maincolor),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  widget.data.product.name,
                  style: TextStyle(
                    fontSize: 19.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$',
                          style:
                              TextStyle(fontSize: 19.sp, color: Colors.brown),
                        ),
                        Text(
                          (widget.data.product.discountedPrice *
                                  (widget.data.itemQty + count))
                              .toString(),
                          style: TextStyle(fontSize: 19.sp),
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
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String id = (prefs.getString('id') ?? '');
                              print('Pressed $id times.');
                              await prefs.setString('id', id);
                              var client = http.Client();

                              try {
                                var url = Uri.parse(
                                    '$baseip/api/order/decrease-item/$id/${widget.data.id}');
                                var response = await http.post(
                                  url,
                                );
                                print(
                                    'Response status: ${response.statusCode}');
                                print('Response body: ${response.body}');
                                if (response.statusCode == 200) {
                                  setState(() {
                                    prices.value = prices.value -
                                        widget.data.product.discountedPrice;
                                    count--;
                                    if (widget.data.itemQty + count == 0) {
                                      print('this is 0');
                                      widget.onDelete();
                                    } else {
                                      setState(() {
                                        bordercolor = const Color(0xffBF6F40);
                                        textcolor = Colors.white;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 550),
                                          () {
                                        setState(() {
                                          textcolor = Colors.black;
                                          //   bordercolor = const Color(0xffDEDEDE);
                                        });
                                      });
                                    }
                                  });
                                }
                              } finally {
                                client.close();
                              }
                            },
                            child: Icon(
                              Icons.remove,
                              size: 16.sp,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            (widget.data.itemQty + count).toString(),
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
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String id = (prefs.getString('id') ?? '');
                            print('Pressed $id times.');
                            await prefs.setString('id', id);
                            var client = http.Client();
                            try {
                              var url = Uri.parse(
                                  '$baseip/api/order/increase-item/$id/${widget.data.id}');
                              var response = await http.post(
                                url,
                              );

                              if (response.statusCode == 200) {
                                setState(() {
                                  prices.value = prices.value +
                                      widget.data.product.discountedPrice;
                                  count++;
                                });
                              }
                            } finally {
                              client.close();
                            }
                            setState(() {
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
            ],
          ),
        ),
      ),
    );
  }
}
