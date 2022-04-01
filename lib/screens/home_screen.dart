import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:bana_care/models/categoryreq.dart';
import 'package:bana_care/models/prduect.dart';
import 'package:bana_care/models/prodeuctreq.dart';
import 'package:bana_care/screens/login_screen.dart';
import 'package:bana_care/screens/search_screen.dart';
import 'package:bana_care/widgets/productcard.dart';
import 'package:bana_care/widgets/rounded_buttons.dart';
import 'package:bana_care/widgets/row_texticon.dart';
import 'package:bana_care/widgets/shamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late Future<List<Category>> futureData;
  late Future<List<Product>> futuredproduced;
  late Future<List<Product>> futuredpackages;

  void initState() {
    futureData = fetchCategories();
    futuredpackages = fetchListproduects(
        '$baseip/api/products?Categorys=9584b078-9225-4930-948d-9384f810c390');
    futuredproduced = fetchListproduects(
        '$baseip/api/products?Categorys=c7bbbac7-5574-4624-a913-f836ca35d5bb');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    super.build(context);
    return SingleChildScrollView(
        child: Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What would you like to order',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text('Login'))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Container(
            width: 100.w,
            height: 5.h,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: AnimSearchBar(
              width: 400,
              textController: textController,
              prefixIcon: Icon(Icons.search_outlined),
              suffixIcon: Icon(Icons.search_outlined),
              closeSearchOnSuffixTap: false,
              helpText: 'Search for product',
              onSuffixTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => searchscreen(
                              name: textController.text,
                            )),
                  );
                });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
          ),
          child: SizedBox(
            height: 6.h,
            child: FutureBuilder<List<Category>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Category>? data = snapshot.data;
                  return catagrol_row(
                    data: data,
                  );
                } else if (snapshot.hasError) {
                  return shamer();
                }
                return shamer();
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 6.w,
            right: 6.w,
            top: 2.h,
          ),
          child: RowTextIcon(
            text: 'Featured Packages',
            tag: '9584b078-9225-4930-948d-9384f810c390',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
          ),
          child: SizedBox(
            height: 27.h,
            child: FutureBuilder<List<Product>>(
              future: futuredpackages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product>? data = snapshot.data;
                  return featurdpackeges(
                    data: data,
                  );
                } else if (snapshot.hasError) {
                  return shamer();
                }
                return shamer();
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 6.w,
            right: 6.w,
            top: 2.h,
          ),
          child: RowTextIcon(
            text: 'Featured Products',
            tag: 'c7bbbac7-5574-4624-a913-f836ca35d5bb',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
          ),
          child: SizedBox(
            height: 27.h,
            child: FutureBuilder<List<Product>>(
              future: futuredproduced,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product>? data = snapshot.data;
                  return featuredproduects(
                    data: data,
                  );
                } else if (snapshot.hasError) {
                  return shamer();
                }
                return shamer();
              },
            ),
          ),
        ),
      ],
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class featuredproduects extends StatelessWidget {
  const featuredproduects({Key? key, required this.data}) : super(key: key);
  final List<Product>? data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(data!.length, (int index) {
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: ProductCard(
            title: 'Product$index',
            width: 60.w,
            id: data![index].id,
            price: data![index].discountedPrice.toString(),
            caver: data![index].image,
            product: data![index],
          ),
        );
      }),
    );
  }
}

class featurdpackeges extends StatelessWidget {
  const featurdpackeges({Key? key, required this.data}) : super(key: key);
  final List<Product>? data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(data!.length, (int index) {
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: ProductCard(
            title: 'details',
            width: 68.w,
            id: data![index].id,
            product: data![index],
            caver: data![index].image,
            price: data![index].discountedPrice.toString(),
          ),
        );
      }),
    );
  }
}

class catagrol_row extends StatelessWidget {
  const catagrol_row({
    Key? key,
    required this.data,
  }) : super(key: key);
  final List<Category>? data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(data!.length, (int index) {
        return RoundedButton(tag: data![index].id, name: data![index].name);
      }),
    );
  }
}
