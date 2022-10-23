import 'package:flutter/material.dart';

class AbandonedCart extends StatefulWidget {
  AbandonedCart({Key? key}) : super(key: key);

  @override
  State<AbandonedCart> createState() => _AbandonedCartState();
}

class _AbandonedCartState extends State<AbandonedCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abandoned Cart"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text("Customer"),
        ],
      )),
    );
  }
}
