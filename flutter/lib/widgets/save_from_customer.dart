import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';

class SaveFromCustomer extends StatefulWidget {
  SaveFromCustomer({Key? key}) : super(key: key);

  @override
  State<SaveFromCustomer> createState() => _SaveFromCustomerState();
}

class _SaveFromCustomerState extends State<SaveFromCustomer> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExcelManipulationBloc>(context);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await bloc.setCustomerFile();
            },
            child: Text("SET"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await bloc.readCustomerFromFile();
            },
            child: Text("Read"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              await bloc.saveCustomersFromFile();
            },
            child: Text("SAVE"),
          ),
        ),
      ],
    );
  }
}
