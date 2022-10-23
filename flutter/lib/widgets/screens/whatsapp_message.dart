import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawabel/bloc/webview_bloc.dart';
import 'package:tawabel/widgets/web_site_view.dart';

class WhatsappMessage extends StatefulWidget {
  WhatsappMessage({Key? key}) : super(key: key);

  @override
  State<WhatsappMessage> createState() => _WhatsappMessageState();
}

class _WhatsappMessageState extends State<WhatsappMessage> {
  @override
  void initState() {
    super.initState();
    WebViewBloc webViewBloc = Provider.of<WebViewBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (webViewBloc.shouldOpenNewPage) {
          await webViewBloc.openIndianVisaSite();
        }
        // await webViewBloc.checkHomepage();
        webViewBloc.shouldOpenNewPage = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WebViewBloc webViewBloc = Provider.of<WebViewBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Send message"),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  // await webViewBloc.reloadPage();
                  await webViewBloc.sendMessage();
                },
                child: Text("Test 1"))
          ],
        ),
        body: WebSiteView(
          controller: webViewBloc.controller,
          // width: 700,
        ));

    //   return Column(
    //     children: [
    //       if (webViewBloc.error != null)
    //         Padding(
    //           padding: const EdgeInsets.only(top: 30),
    //           child: Text(
    //             webViewBloc.error!,
    //           ),
    //         ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 20, bottom: 10),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Flexible(
    //               child: Wrap(
    //                 children: [],
    //               ),
    //             ),
    //             Flexible(
    //               child: Wrap(
    //                 alignment: WrapAlignment.end,
    //                 runSpacing: 10,
    //                 children: [],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       const Divider(
    //         thickness: 2,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: LayoutBuilder(
    //           builder: (context, constraints) => Wrap(
    //             children: [
    //               // Container(
    //               //   width: constraints.maxWidth * .7,
    //               //   color: Colors.blue,
    //               //   child: SizedBox(
    //               //       width: 700,
    //               //       height: 1200,
    //               //       child: WebSiteView(
    //               //         controller: webViewBloc.controller,
    //               //         // width: 700,
    //               //       )),
    //               // ),
    //               SizedBox(
    //                 width: constraints.maxWidth * .3,
    //                 child: Column(
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           width: double.infinity,
    //                           padding:
    //                               const EdgeInsets.symmetric(horizontal: 10),
    //                           decoration: BoxDecoration(
    //                             color: Colors.purple,
    //                             borderRadius: BorderRadius.circular(10),
    //                           ),
    //                           child: Wrap(
    //                             crossAxisAlignment: WrapCrossAlignment.center,
    //                             alignment: WrapAlignment.spaceBetween,
    //                             children: [
    //                               Text(
    //                                 "Event",
    //                                 textAlign: TextAlign.center,
    //                               ),
    //                               IconButton(
    //                                 onPressed: () {},
    //                                 icon: Icon(
    //                                   Icons.remove_red_eye,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         const SizedBox(
    //                           height: 50,
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       // const Divider(
    //       //   thickness: 2,
    //       // ),
    //       // Padding(
    //       //   padding: const EdgeInsets.only(top: 20, bottom: 20),
    //       //   child: Wrap(
    //       //     alignment: WrapAlignment.center,
    //       //     runSpacing: 10,
    //       //     children: [],
    //       //   ),
    //       // ),
    //       // const Divider(
    //       //   thickness: 5,
    //       // ),

    //       const SizedBox(
    //         height: 50,
    //       ),
    //     ],
    //   ),
    // );
  }
}
