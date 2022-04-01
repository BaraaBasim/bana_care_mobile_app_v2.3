import 'package:bana_care/assets/Colors/maincolors.dart';
import 'package:bana_care/models/prduect.dart';
import 'package:bana_care/models/prodeuctreq.dart';
import 'package:bana_care/widgets/shamer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

late Future<List<Order>> _myData;

late Future<List<Order>> laterData;

class orders extends StatefulWidget {
  const orders({Key? key}) : super(key: key);

  @override
  _ordersState createState() => _ordersState();
}

Color textcolor = Colors.black;
Color bordercolor = const Color(0xffBF6F40);
Color color = Colors.black;

class _ordersState extends State<orders> with AutomaticKeepAliveClientMixin {
  void initState() {
    _myData = fetchorder();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    laterData = fetchorder();
    if (_myData != laterData) {
      setState(() {
        _myData = laterData;
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Material(
          type: MaterialType.transparency,
          child: Text(
            'Orders',
            style: TextStyle(fontSize: 22.sp, color: maincolor),
          ),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _myData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Order>? data = snapshot.data;
            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: List.generate(data!.length, (int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 2.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].items.length.toString(),
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '\$',
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.brown),
                                    ),
                                    Text(
                                      data[index].total.toString(),
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      Size.fromWidth(30.w)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side:
                                              BorderSide(color: bordercolor))),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xffBF6F40)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(color),
                                ),
                                onPressed: () async {
                                  print(data[index].id);
                                  var client = http.Client();
                                  try {
                                    var url = Uri.parse(
                                        '$baseip/api/order/delete_order/${data[index].id}');
                                    var response = await http.get(
                                      url,
                                    );

                                    if (response.statusCode == 200) {
                                      Alert(
                                        context: context,
                                        type: AlertType.error,
                                        title: "Order state",
                                        desc: "Your order has been cancelled",
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            width: 120,
                                          )
                                        ],
                                      ).show();
                                      setState(() {
                                        _myData = fetchorder();
                                      });
                                      setState(() {
                                        color = Colors.white;
                                      });
                                    }
                                  } finally {
                                    client.close();
                                  }
                                  setState(() {
                                    color = Colors.white;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 350), () {
                                    setState(() {
                                      color = Colors.black;
                                    });
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      Size.fromWidth(30.w)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          side:
                                              BorderSide(color: bordercolor))),
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xffBF6F40)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(color),
                                ),
                                onPressed: () {
                                  setState(() {
                                    //  color = Colors.white;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 350), () {
                                    setState(() {
                                      //color = Colors.black;
                                    });
                                  });
                                },
                                child: Text(
                                  '${data[index].title}',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          } else if (snapshot.hasError) {
            return shamer();
          }
          return shamer();
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
