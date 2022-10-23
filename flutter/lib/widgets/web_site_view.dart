import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class WebSiteView extends StatelessWidget {
  final WebviewController controller;
  final double? width;
  const WebSiteView({Key? key, this.width, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      color: Colors.yellow,
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: [
            Webview(
              controller,
              width: width,
            ),
            // StreamBuilder<LoadingState>(
            //   stream: controller.loadingState,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData && snapshot.data == LoadingState.loading) {
            //       return const LinearProgressIndicator();
            //     } else {
            //       return Container();
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
