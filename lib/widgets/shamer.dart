import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class shamer extends StatefulWidget {
  const shamer({Key? key}) : super(key: key);

  @override
  _shamerState createState() => _shamerState();
}

class _shamerState extends State<shamer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: 90.w,
          height: 100.h,
          child: FadeShimmer(
            height: 100,
            millisecondsDelay: 0,
            width: 150,
            radius: 4,
            highlightColor: Color(0xffF9F9FB),
            baseColor: Color(0xffE6E8EB),
          )),
    );
  }
}
