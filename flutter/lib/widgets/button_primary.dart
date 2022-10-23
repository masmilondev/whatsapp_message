import 'package:flutter/material.dart';
import 'package:tawabel/utils/constant.dart';

class ButtonPrimary extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String text;
  final double? width;
  final double? height;

  const ButtonPrimary({
    Key? key,
    required this.color,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => onPressed(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Constant.colors[0],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
