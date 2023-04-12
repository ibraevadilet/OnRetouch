import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Info',
                  style: AppTextStyles.s24W500(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),
                Image.asset(AppImages.info1),
                const SizedBox(height: 25),
                Image.asset(AppImages.info3),
                const SizedBox(height: 25),
                Image.asset(AppImages.info4),
                const SizedBox(height: 25),
                Image.asset(AppImages.info5),
                const SizedBox(height: 25),
                Image.asset(AppImages.info2),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
