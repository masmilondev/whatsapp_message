import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';
import 'package:tawabel/models/customer_model.dart';
import 'package:tawabel/widgets/screens/search_contacts.dart';

class FilterExcelFile extends StatefulWidget {
  FilterExcelFile({Key? key}) : super(key: key);

  @override
  State<FilterExcelFile> createState() => _FilterExcelFileState();
}

class _FilterExcelFileState extends State<FilterExcelFile> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();
    final excelMainulation = Provider.of<ExcelManipulationBloc>(context);
    String? status = excelMainulation.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (status != null)
              Text(
                status,
                style: const TextStyle(fontSize: 30),
              ),
            if (status == null)
              const Text(
                "Your app is ready!",
                style: TextStyle(fontSize: 30),
              ),
            const Divider(
              thickness: 3,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                  "Set new customer file, this will delete old data from the database. Save the customer file to assets/files folder."),
            ),
            Wrap(
              runAlignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await excelMainulation.setExcelFile();
                    },
                    child: const Text("Set excel file"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      excelMainulation.readCustomers();
                    },
                    child: const Text("2. Check data"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      excelMainulation.addAllCustomer();
                    },
                    child: const Text("2. Save to database"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      excelMainulation.getData();
                    },
                    child: const Text("Check data"),
                  ),
                ),
              ],
            ),
            const Text("Whatsapp message operations"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SearchContact(),
                  ),
                );
              },
              child: const Text("Filter customer"),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: "Please, write your message here"),
              controller: _messageController,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await excelMainulation.openBrowser();
                    },
                    child: const Text("Open browser"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await excelMainulation.sendBatchMessage();
                    },
                    child: const Text("Send message"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
 ElevatedButton(
              onPressed: () async {
                excelMainulation.saveCustomers();
              },
              child: const Text("Save to json"),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String result = await excelMainulation.filterAll();

                    setState(() {
                      status = result;
                    });
                  },
                  child: const Text("Filter"),
                ),
              ],
            ),
*/



