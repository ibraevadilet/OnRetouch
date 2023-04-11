import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:rate_my_app/rate_my_app.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'config/app_config.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webController;
  late String webViewUrl;
  // RateMyApp rateMyApp = RateMyApp(appStoreIdentifier: AppConfig.appStoreIdentifier);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    webViewUrl = widget.url;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await rateMyApp.init();
      await Future.delayed(const Duration(seconds: 5));
      // rateMyApp.showRateDialog(context);
    });
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _enableRotation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if ((await _webController?.canGoBack()) ?? false) {
          await _webController?.goBack();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: WebView(
            gestureNavigationEnabled: true,
            initialUrl: webViewUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (con) {
              print('complete');
              _webController = con;
            },
          ),
        ),
      ),
    );
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
