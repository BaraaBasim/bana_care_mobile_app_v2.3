import 'dart:async';

import 'package:bana_care/screens/cart_screen.dart';
import 'package:bana_care/screens/home_screen.dart';
import 'package:bana_care/screens/login_screen.dart';
import 'package:bana_care/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:oktoast/oktoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'assets/Colors/maincolors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
  //test
}

String baseip = 'http://hosin211.pythonanywhere.com';
int _selectedItemPosition = 0;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bana Care',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            hintColor: maincolor,
          ),
          home: const MyHomePage(),
        ),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();
  late Timer _timer;

  bool showLogin = true;

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 500), () {
      _pageController.jumpToPage(2);
      _pageController.jumpToPage(0);
      // SOMETHING
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (int) {
            setState(() {
              _selectedItemPosition = int;
            });
          },
          children: [
            Home(),
            cart(),
            orders(),
          ],
        ),
      ),
      bottomNavigationBar: buttonbarnav(pageController: _pageController),
    );
  }
}

class buttonbarnav extends StatefulWidget {
  const buttonbarnav({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  State<buttonbarnav> createState() => _buttonbarnavState();
}

class _buttonbarnavState extends State<buttonbarnav> {
  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      // height: 80,
      behaviour: SnakeBarBehaviour.floating,
      snakeShape: SnakeShape.rectangle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.all(10),
      backgroundColor: Colors.white,

      ///configuration for SnakeNavigationBar.color
      snakeViewColor: maincolor,
      selectedItemColor:
          SnakeShape.circle == SnakeShape.indicator ? maincolor : null,
      unselectedItemColor: Colors.blueGrey,

      showUnselectedLabels: true,
      showSelectedLabels: true,

      currentIndex: _selectedItemPosition,
      onTap: (index) {
        setState(() {
          widget.pageController.animateToPage(index,
              curve: Curves.decelerate, duration: Duration(milliseconds: 300));
          _selectedItemPosition = index;
        });
      },
      height: 6.h,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined), label: 'Shop'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      ],
      selectedLabelStyle: const TextStyle(fontSize: 14),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
    );
  }
}
