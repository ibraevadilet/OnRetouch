// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:apphud/apphud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/feature/auth/splash_screen.dart';
import 'package:on_retouch/web_page.dart';
import 'package:traffic_router/traffic_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/notification_service.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Apphud.start(apiKey: 'app_KqEVHrgNVsHxLRauiYtoyksNPLJm4H');

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDKKE2RQ6S_y03xxcC4H7P6121aOb9CYJ8',
      appId: '1:263963822655:ios:c5f4a0ff8507ff0f66468a',
      messagingSenderId: '263963822655',
      projectId: 'on-retouch',
      storageBucket: 'on-retouch.appspot.com',
    ),
  );

  final trafficRouter = await TrafficRouter.initialize(
    settings: const RouterSettings(
      paramNames: ParamNames(
        databaseRoot: 'json_root',
        baseUrl1: 'on',
        baseUrl2: 'retouch',
        url11key: 'photos',
        url12key: 'collage',
        url21key: 'filters',
        url22key: 'editors',
      ),
    ),
  );
  if (trafficRouter.url.isEmpty) {
    runApp(MyApp());
  } else {
    if (trafficRouter.override) {
      if (kDebugMode) {
        print('traffic router OVERRIDED');
      }
      await _launchInBrowser(trafficRouter.url);
    } else {
      if (kDebugMode) {
        print('WEBVIEW STARTING ${trafficRouter.url}');
      }
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WebViewPage(
            url: trafficRouter.url,
          ),
        ),
      );
    }
  }

  NotificationService notificationService = NotificationService();
  notificationService.activate();
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      debugShowCheckedModeBanner: false,
      title: 'OnRetouch',
      theme: ThemeData(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: SplashScreen(),
    );
  }
}
