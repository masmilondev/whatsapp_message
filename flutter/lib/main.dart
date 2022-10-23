import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/excel_manipulation_bloc.dart';
import 'package:tawabel/bloc/webview_bloc.dart';
import 'package:tawabel/data_provider/objectBox.dart';
import 'package:tawabel/utils/constant.dart';
import 'package:tawabel/widgets/button_primary.dart';
import 'package:tawabel/widgets/screens/abandoned_cart.dart';
import 'package:tawabel/widgets/screens/customer_message.dart';
import 'package:tawabel/widgets/screens/filter_excel_file.dart';
import 'package:tawabel/widgets/screens/save_customer.dart';
import 'package:tawabel/widgets/screens/whatsapp_message.dart';

ObjectBox? objectBox;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    objectBox = await ObjectBox.create();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ExcelManipulationBloc>(
              create: (_) => ExcelManipulationBloc()),
          ChangeNotifierProvider<WebViewBloc>(create: (_) => WebViewBloc()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const InitApp(),
    );
  }
}

class InitApp extends StatefulWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  bool _isDBError = false;

  @override
  void initState() {
    super.initState();
    if (objectBox == null) {
      _isDBError = true;
    }
    ExcelManipulationBloc bloc =
        Provider.of<ExcelManipulationBloc>(context, listen: false);
    bloc.setObjectBox(objectBox);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    WebViewBloc webViewBloc = Provider.of<WebViewBloc>(context);

    return _isDBError == true
        ? const Scaffold(
            body: Text("DB Error, please reload the app"),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Tawabel"),
            ),
            body: Center(
              child: Column(
                children: [
                  ButtonPrimary(
                    color: Constant.colors[1],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SaveCustomers(),
                        ),
                      );
                    },
                    text: "Customer",
                    width: size.width,
                  ),
                  ButtonPrimary(
                    color: Constant.colors[1],
                    onPressed: () {
                      print("Abandoned cart");
                    },
                    text: "Abandoned cart",
                    width: size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        await webViewBloc.openIndianVisaSite();
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  AbandonedCart(),
                            ));
                      },
                      child: Text("Abandoned Cart"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  CustomerMessage(),
                            ));
                      },
                      child: Text("Customer message"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        await webViewBloc.openIndianVisaSite();
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  WhatsappMessage(),
                            ));
                      },
                      child: Text("Whatsapp"),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
