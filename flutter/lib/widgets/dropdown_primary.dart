import 'package:flutter/material.dart';

class DropdownPrimary<T> extends StatelessWidget {
  final String? labelTextTop;
  final EdgeInsets? padding;
  final double? width;
  final T? value;
  final void Function(T?)? onChanged;
  final List<T>? items;
  final Widget? iconButton;

  DropdownPrimary({
    Key? key,
    this.width,
    this.onChanged,
    this.padding,
    this.iconButton,
    this.value,
    this.items,
    this.labelTextTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 15);

    return SizedBox(
      // width: 100,
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (labelTextTop != null)
              Text(
                labelTextTop ?? "",
                style: textStyle,
              ),
            if (labelTextTop != null)
              SizedBox(
                height: 3,
              ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(.5),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: DropdownButton<T>(
                  icon: iconButton,
                  value: value,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12.0),
                  style: textStyle,
                  underline: Container(),
                  onChanged: onChanged,
                  items: items?.map<DropdownMenuItem<T>>(
                    (T v) {
                      String? name;
                      switch (v.runtimeType) {
                        case String:
                          name = v as String;
                          break;
                        default:
                      }

                      return DropdownMenuItem<T>(
                        value: v,
                        child: Center(
                            child: Text(
                          name ?? "",
                          style: textStyle,
                        )),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
