// import 'package:apphud/apphud.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app_config.dart';

// class CheckRestore {
//   static void checkRestore(context) async {
//     final hasPremiumAccess = await Apphud.hasPremiumAccess();
//     final hasActiveSubscription = await Apphud.hasActiveSubscription();
//     if (hasPremiumAccess || hasActiveSubscription) {
//       final prefs = await SharedPreferences.getInstance();
//       prefs.setBool("ISBUY", true);
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: const Text('Success!'),
//           content: const Text('Your purchase has been restored!'),
//           actions: [
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) => CupertinoAlertDialog(
//           title: const Text('Restore purchase'),
//           content: const Text(
//               'Your purchase is not found.\nSupport: ${AppConfig.supportForm}'),
//           actions: [
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               onPressed: () => {Navigator.of(context).pop()},
//               child: const Text('Ok'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
