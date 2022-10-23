import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';
import 'package:tawabel/enums/customer_status_enum.dart';
import 'package:tawabel/enums/customer_type_enum.dart';
import 'package:tawabel/enums/filter_enums.dart';

class CustomerMessage extends StatefulWidget {
  CustomerMessage({Key? key}) : super(key: key);

  @override
  State<CustomerMessage> createState() => _CustomerMessageState();
}

class _CustomerMessageState extends State<CustomerMessage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ExcelManipulationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customer message",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                bloc.systemStatus,
              ),
            ),
            ExpansionTile(
              title: Text("Database management"),
              children: [
                ListTile(
                  title: ElevatedButton(
                    onPressed: () {
                      bloc.seeAllCustomers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("See all customers".toUpperCase()),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                      onPrimary: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Clear status"),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
              ],
            ),
            Divider(),
            Divider(
              thickness: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroInMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.unknown,
                      );
                    },
                    child: Text("zero In Madina".toUpperCase()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroInMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.success,
                      );
                    },
                    child: Text("Success"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroInMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.error,
                      );
                    },
                    child: Text("Error"),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroOutMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.unknown,
                      );
                    },
                    child: Text("zero Out Madina".toUpperCase()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroOutMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.success,
                      );
                    },
                    child: Text("Success"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      bloc.findCustomers(
                        FilterEnums.zeroOutMadina,
                        CustomerTypeEnum.customer,
                        CustomerStatusEnum.error,
                      );
                    },
                    child: Text("Error"),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await bloc.openBrowser();
                },
                child: Text("Open browser"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await bloc.openWhatsApp();
                },
                child: Text("Open whatsapp"),
              ),
            ),
            Divider(
              thickness: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      bloc.seeMessage();
                    },
                    child: Text("See message"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await bloc.sendBatchMessage();
                    },
                    child: Text("Send message"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  hintText: "Please, write your message here"),
              controller: _messageController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  bloc.setMessage(_messageController.text);
                  _messageController.text = "";
                },
                child: Text("Set messages"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: bloc.tawabelCustomersResult
                  .map(
                    (e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(e.name),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.mobile),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.status),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.city ?? ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e.numberOfOrder.toString()),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
