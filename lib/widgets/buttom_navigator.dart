import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/feature/home/home_screen.dart';
import 'package:on_retouch/feature/info/info_screen.dart';
import 'package:on_retouch/feature/settings/settings_screen.dart';
import 'package:on_retouch/feature/studio/studio_screen.dart';

class BottomNavigatorScreen extends StatefulWidget {
  const BottomNavigatorScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorScreen> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigatorScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.white.withOpacity(0.5),
        currentIndex: index,
        onTap: (indexFrom) {
          setState(() {
            index = indexFrom;
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              AppImages.navbarHomeActive,
              height: 30,
            ),
            icon: Image.asset(
              AppImages.navbarHome,
              height: 30,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              AppImages.navbarStudioActive,
              height: 30,
            ),
            icon: Image.asset(
              AppImages.navbarStudio,
              height: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              AppImages.navbarInfoActive,
              height: 30,
            ),
            icon: Image.asset(
              AppImages.navbarInfo,
              height: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(
              AppImages.navbarSettingsActive,
              height: 30,
            ),
            icon: Image.asset(
              AppImages.navbarSettings,
              height: 30,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

List<Widget> pages = [
  const HomeScreen(),
  const StudioScreen(),
  const InfoScreen(),
  const SettingsScreen(),
];
