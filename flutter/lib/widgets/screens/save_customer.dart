import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';
import 'package:tawabel/enums/filter_enums.dart';
import 'package:tawabel/utils/filter_data.dart';
import 'package:tawabel/widgets/button_primary.dart';
import 'package:tawabel/widgets/dropdown_primary.dart';
import 'package:tawabel/widgets/save_from_customer.dart';
import 'package:tawabel/widgets/text_container.dart';

class SaveCustomers extends StatefulWidget {
  SaveCustomers({Key? key}) : super(key: key);

  @override
  State<SaveCustomers> createState() => _SaveCustomers();
}

class _SaveCustomers extends State<SaveCustomers> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExcelManipulationBloc>(context);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Save Customer"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  bloc.systemStatus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                "Total To send:  ${bloc.totalToSend}\n Remaining: ${bloc.remaining}\n  Sent: ${bloc.sent}",
                textAlign: TextAlign.center,
              ),
              ExpansionTile(
                backgroundColor: Colors.blue.shade50,
                collapsedBackgroundColor: Colors.red.shade100,
                title: Text(
                  "Message settings".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Please, write your message here"),
                      controller: _messageController,
                    ),
                  ),
                  ButtonPrimary(
                    color: Colors.green.shade600,
                    onPressed: () async {
                      bloc.setMessage(_messageController.text);
                      _messageController.text = "";
                    },
                    text: "Set messages",
                  ),
                  ButtonPrimary(
                    color: Colors.green.shade900,
                    onPressed: () async {
                      bloc.seeMessage();
                    },
                    text: "Show messages",
                  ),
                ],
              ),
              ExpansionTile(
                backgroundColor: Colors.purple.shade50,
                collapsedBackgroundColor: Colors.purple.shade100,
                title: Text(
                  "Message management".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                children: [
                  Divider(thickness: 1, color: Colors.red),
                  Text(
                    bloc.filterStatus,
                    textAlign: TextAlign.center,
                  ),
                  Divider(thickness: 1, color: Colors.blue),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownPrimary<String>(
                      items: FilterData.filterList,
                      onChanged: (v) {
                        print(v);
                        bloc.setFilterBy(v);
                      },
                      value: bloc.filterBy,
                      labelTextTop: "Filter by",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownPrimary<String>(
                      items: FilterData.customerStatusList,
                      onChanged: (v) {
                        print(v);
                        bloc.setCustomerStatus(v);
                      },
                      value: bloc.customerStatus,
                      labelTextTop: "Customer status",
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      children: [
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.teal,
                            onPressed: () async {
                              bloc.searchCustomer();
                            },
                            text: "Filter",
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.teal.shade900,
                            onPressed: () async {
                              bloc.showAllCustomers();
                            },
                            text: "Show All",
                          ),
                        ),
                        Divider(thickness: 1, color: Colors.red),
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.green.shade700,
                            onPressed: () async {
                              await bloc.sendBatchMessage();
                            },
                            text: "Send",
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.red.shade900,
                            onPressed: () async {
                              bloc.stopMessage();
                            },
                            text: "Stop",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                backgroundColor: Colors.blue.shade50,
                collapsedBackgroundColor: Colors.red.shade100,
                title: Text(
                  "App Management".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                      children: [
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.green,
                            onPressed: () async {
                              await bloc.spinner(bloc.openBrowser());
                            },
                            text: "Open Browser",
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth / 2,
                          padding: const EdgeInsets.only(top: 10),
                          child: ButtonPrimary(
                            color: Colors.orange.shade700,
                            onPressed: () async {
                              await bloc.spinner(bloc.openWhatsApp());
                            },
                            text: "Open whatsapp",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ButtonPrimary(
                      color: Colors.red.shade900,
                      onPressed: () async {
                        bloc.closeBrowser();
                      },
                      text: "Close Browser",
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                backgroundColor: Colors.green.shade50,
                collapsedBackgroundColor: Colors.blue.shade100,
                title: Text(
                  "Customer management".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                children: [
                  Divider(thickness: 1, color: Colors.green),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ButtonPrimary(
                        color: Colors.amber.shade900,
                        onPressed: () async {
                          bloc.isCustomer = true;
                          bool isFileOkay =
                              await bloc.spinner(bloc.setExcelFile());
                          if (!isFileOkay) return;

                          bool data = await bloc.spinner(bloc.readCustomers());
                          if (!data) return;

                          await bloc.spinner(bloc.readCustomerFromFile());
                        },
                        text: "Customer",
                        width: (width / 2) - 20,
                      ),
                      ButtonPrimary(
                        color: Colors.green,
                        onPressed: () async {
                          await bloc.spinner(bloc.saveCustomersFromFile());
                        },
                        text: "Save",
                        width: (width / 2) - 20,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ButtonPrimary(
                        color: Colors.amber.shade900,
                        onPressed: () async {
                          bloc.isCustomer = false;
                          bool isFileOkay =
                              await bloc.spinner(bloc.setExcelFile());
                          if (!isFileOkay) return;

                          bool data = await bloc.spinner(bloc.readAbandoned());
                          if (!data) return;

                          // await bloc.spinner(bloc.readCustomerFromFile());
                        },
                        text: "Abandoned",
                        width: (width / 2) - 20,
                      ),
                      ButtonPrimary(
                        color: Colors.green,
                        onPressed: () async {
                          await bloc.spinner(bloc.saveAbandonedFromFile());
                        },
                        text: "Save",
                        width: (width / 2) - 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Write here to search"),
                      controller: _searchNumberController,
                    ),
                  ),
                  ButtonPrimary(
                    color: Colors.green.shade900,
                    onPressed: () async {
                      print(_searchNumberController.text);
                      bloc.searchCustomerByText(_searchNumberController.text);
                    },
                    text: "Search",
                    // width: (width / 2) - 20,
                  ),
                  SizedBox(height: 20),
                ],
              ),
              ExpansionTile(
                backgroundColor: Colors.blue.shade50,
                collapsedBackgroundColor: Colors.red.shade300,
                title: Text(
                  "reset".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                children: [
                  Divider(thickness: 1, color: Colors.red),
                  SizedBox(height: 30),
                  ButtonPrimary(
                    color: Colors.pink.shade900,
                    onPressed: () async {
                      bloc.clearCustomerStatus();
                    },
                    text: "Clear status",
                  ),
                  SizedBox(height: 30),
                  ButtonPrimary(
                    color: Colors.red,
                    onPressed: () async {
                      await bloc.spinner(bloc.clearCustomer());
                    },
                    text: "Delete customers",
                  ),
                  ButtonPrimary(
                    color: Colors.orange,
                    onPressed: () async {
                      await bloc.spinner(bloc.clearAbandoned());
                    },
                    text: "Delete Abandoned",
                  ),
                  SizedBox(height: 30),
                ],
              ),
              if (bloc.isCustomer == true)
                ...bloc.tawabelCustomers.map(
                  (e) => Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextContainer(e.name),
                        TextContainer(e.mobile),
                        TextContainer(e.status),
                        TextContainer(e.city ?? ""),
                        TextContainer(e.numberOfOrder.toString()),
                        if (e.isBlock == true)
                          IconButton(
                              onPressed: () {
                                // Show popup to confirm
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                        "You are about to unblock ${e.name}"),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Unblock"),
                                        onPressed: () async {
                                          await bloc.spinner(
                                              bloc.unblockCustomer(
                                                  e.id,
                                                  _searchNumberController
                                                      .text));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.block,
                                color: Colors.red,
                              )),
                        if (e.isBlock != true)
                          IconButton(
                              onPressed: () {
                                // Show popup to confirm
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                        "You are about to block ${e.name}"),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Block"),
                                        onPressed: () async {
                                          await bloc.spinner(bloc.blockCustomer(
                                              e.id,
                                              _searchNumberController.text));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.block,
                                color: Colors.green,
                              )),
                      ],
                    ),
                  ),
                ),
              if (bloc.isCustomer == false)
                ...bloc.abandoned.map(
                  (e) => Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextContainer(e.name),
                        TextContainer(e.mobile),
                        TextContainer(e.status!),
                        TextContainer(e.amount!.toStringAsFixed(2)),
                        TextContainer(e.numberOfProduct.toString()),
                        if (e.isBlocked == true)
                          IconButton(
                              onPressed: () {
                                // Show popup to confirm
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                        "You are about to unblock ${e.name}"),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Unblock"),
                                        onPressed: () async {
                                          await bloc.spinner(
                                              bloc.unblockCustomer(
                                                  e.id,
                                                  _searchNumberController
                                                      .text));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.block,
                                color: Colors.red,
                              )),
                        if (e.isBlocked != true)
                          IconButton(
                              onPressed: () {
                                // Show popup to confirm
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                        "You are about to block ${e.name}"),
                                    actions: [
                                      ElevatedButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text("Block"),
                                        onPressed: () async {
                                          await bloc.spinner(bloc.blockCustomer(
                                              e.id,
                                              _searchNumberController.text));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.block,
                                color: Colors.green,
                              )),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 120),
            ],
          ),
          if (bloc.getSpinner) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
      /*
       SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(bloc.systemStatus),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SaveFromCustomer(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Read files from DB"),
              ),
              ElevatedButton(
                  onPressed: () {
                    bloc.countCustomers();
                  },
                  child: Text("Count on DB")),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("DB Action"),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bloc.clearCustomer();
                    },
                    child: Text("Clear customers"),
                  ),
                ],
              ),
              ...bloc.tawabelCustomers.map(
                (e) => Row(
                  children: [
                    Text(e.name),
                    Text(e.mobile),
                    Text(e.status),
                    Text(e.city ?? ""),
                    Text(e.numberOfOrder.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}

*/