import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Camera extends StatelessWidget {
  Camera({super.key});

  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://www.dcfever.com/trading/listing.php?id=1'));

  @override
  Widget build(BuildContext context) {
    // return Text("data");
    return WebViewWidget(controller: controller);
  }
}