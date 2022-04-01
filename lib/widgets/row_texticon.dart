import 'package:bana_care/screens/catagerl_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RowTextIcon extends StatefulWidget {
  const RowTextIcon({Key? key, required this.text, required this.tag})
      : super(key: key);
  final String text, tag;

  @override
  State<RowTextIcon> createState() => _RowButtonState();
}

Color color = Colors.black;

class _RowButtonState extends State<RowTextIcon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: TextStyle(fontSize: 18.sp),
        ),
        TextButton.icon(
          style: ButtonStyle(
            overlayColor:
                MaterialStateProperty.all<Color>(const Color(0xffBF6F40)),
            foregroundColor: MaterialStateProperty.all<Color>(color),
          ),
          onPressed: () {
            setState(() {
              color = Colors.white;
            });
            Future.delayed(const Duration(milliseconds: 350), () {
              setState(() {
                color = Colors.black;
              });
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => catagierl(
                        tag: widget.tag,
                        name: widget.text,
                      )),
            );
          },
          icon: Text(
            'View All',
            style: TextStyle(fontSize: 16.sp),
          ),
          label: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16.sp,
          ),
        ),
      ],
    );
  }
}
