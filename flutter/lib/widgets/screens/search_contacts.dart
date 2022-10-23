import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';
import 'package:tawabel/enums/filter_enums.dart';

class SearchContact extends StatefulWidget {
  const SearchContact({Key? key}) : super(key: key);

  @override
  State<SearchContact> createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  List<String> filterOption = [
    "zeroInMadina",
    "zeroOutMadina",
    "oneTwoInMadina",
    "oneTwoOutMadina",
    "threeFourInMadina",
    "threeFourOutMadina",
    "fivePlusInMainda",
    "fivePlusOutMainda",
    "unKnownOrderMadina",
    "unKnownOrderOutMadinah",
  ];

  List<String> status = [
    "success",
    "failed",
  ];

  @override
  Widget build(BuildContext context) {
    final excelMainulation = Provider.of<ExcelManipulationBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Search contacts")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                excelMainulation.searchCustomer();
              },
              child: const Text("Search"),
            ),
            const Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Column(
                  children: filterOption
                      .map((e) => Container(
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: () {
                                excelMainulation.setSelectedFilter(e);
                                excelMainulation.searchCustomer();
                              },
                              child: Text(e))))
                      .toList(),
                ),
                Column(
                  children: status
                      .map((e) => Container(
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              onPressed: () {
                                excelMainulation.setSelectedStatus(e);
                                excelMainulation.searchCustomer();
                              },
                              child: Text(e))))
                      .toList(),
                )
              ],
            ),
            const Divider(
              thickness: 5,
            ),
            Text(
              "${excelMainulation.selectedFilter} | ${excelMainulation.selectedStatus}",
            ),
            const Divider(
              thickness: 5,
            ),
            ...excelMainulation.getFilteredCustomer
                .map((e) => Text(e.name))
                .toList(),
          ],
        ),
      ),
    );
  }
}
