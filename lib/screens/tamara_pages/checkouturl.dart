
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutUrl extends StatelessWidget {
  const CheckoutUrl({super.key});

  @override
  Widget build(BuildContext context) {
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
      ..loadRequest(Uri.parse('https://www.youtube.com/'));
    return Container(
      color: kMainColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text('checkout'.tr,
              style: GoogleFonts.cairo(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                ),
              ),),),
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
