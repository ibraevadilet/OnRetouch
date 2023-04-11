import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/feature/auth/on_boarding_screen.dart';
import 'package:on_retouch/widgets/buttom_navigator.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const OnBoardingScreen(),
        ),
        (protected) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: 250,
        ),
      ),
    );
  }
}
