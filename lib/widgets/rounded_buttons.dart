import 'dart:async';

import 'package:bana_care/screens/catagerl_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key? key,
    required this.tag,
    required this.name,
  }) : super(key: key);
  final String tag;
  final String name;

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

Color textcolor = Colors.black;
Color bordercolor = const Color(0xffBF6F40);

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.50.h),
      child: TextButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(30.w, 100.h)),
          overlayColor:
              MaterialStateProperty.all<Color>(const Color(0xffBF6F40)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: bordercolor))),
          foregroundColor: MaterialStateProperty.all<Color>(textcolor),
        ),
        onPressed: () async {
          setState(() {
            bordercolor = const Color(0xffBF6F40);
            textcolor = Colors.white;
          });
          Future.delayed(const Duration(milliseconds: 350), () {
            setState(() {
              textcolor = Colors.black;
              //   bordercolor = const Color(0xffDEDEDE);
            });
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => catagierl(
                      tag: widget.tag,
                      name: widget.name,
                    )),
          );
        },
        child: Hero(
          tag: widget.tag,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }
}
