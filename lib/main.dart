// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

// import 'package:apphud/apphud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/feature/auth/splash_screen.dart';
// import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/app_config.dart';
import 'services/notification_service.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Apphud.start(apiKey: AppConfig.apphudKey);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: AppConfig.firebaseApiKey,
      appId: AppConfig.firebaseAppId,
      messagingSenderId: AppConfig.firebaseMessagingSenderId,
      projectId: AppConfig.firebaseProjectId,
      storageBucket: AppConfig.firebaseStorageBucket,
    ),
  );
  // final trafficRouter = await TrafficRouter.initialize(
  //   settings: const RouterSettings(
  //     paramNames: ParamNames(
  //       databaseRoot: AppConfig.databaseRoot,
  //       baseUrl1: AppConfig.baseUrl1,
  //       baseUrl2: AppConfig.baseUrl2,
  //       url11key: AppConfig.url11key,
  //       url12key: AppConfig.url12key,
  //       url21key: AppConfig.url21key,
  //       url22key: AppConfig.url22key,
  //     ),
  //   ),
  // );
  // if (trafficRouter.url.isEmpty) {
  runApp(MyApp());
  // } else {
  //   if (trafficRouter.override) {
  //     if (kDebugMode) {
  //       print('traffic router OVERRIDED');
  //     }
  //     await _launchInBrowser(trafficRouter.url);
  //   } else {
  //     if (kDebugMode) {
  //       print('WEBVIEW STARTING ${trafficRouter.url}');
  //     }
  //     runApp(
  //       MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         home: WebViewPage(
  //           url: trafficRouter.url,
  //         ),
  //       ),
  //     );
  //   }
  // }
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
  // RateMyApp rateMyApp =
  //     RateMyApp(appStoreIdentifier: AppConfig.appStoreIdentifier);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await rateMyApp.init();
      await Future.delayed(const Duration(seconds: 10));
      // rateMyApp.showRateDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      debugShowCheckedModeBanner: false,
      title: 'StropChaffir',
      theme: ThemeData(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      home: SplashScreen(),
    );
  }
}
