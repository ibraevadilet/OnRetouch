import 'package:flutter/material.dart';
import 'package:on_retouch/config/app_config.dart';
import 'package:on_retouch/config/check_premium.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/auth/page_view.dart';
import 'package:on_retouch/feature/auth/premium_screen.dart';
import 'package:on_retouch/web_view_screen.dart';
import 'package:on_retouch/widgets/buttom_navigator.dart';
import 'package:on_retouch/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();
  int currantPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color38B6FFBlue,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  currantPage = value;
                });
              },
              controller: controller,
              children: const [
                PageViewWidget(
                  title: 'Edit your photos\nquickly and easily',
                  image: AppImages.pageView1,
                ),
                PageViewWidget(
                  title: 'Save and share your\nphotos',
                  image: AppImages.pageView2,
                ),
                PageViewWidget(
                  title: 'Perfect any photo\nusing tools and filters',
                  image: AppImages.pageView3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: const WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      dotColor: Colors.white,
                      activeDotColor: AppColors.color0180F5BlueDark,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    color: Colors.white,
                    text: 'Next',
                    onPressed: () async {
                      final isBuy = await CheckPremium.getSubscription();
                      if (currantPage == 2) {
                        if (!isBuy) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PremiumScreen(),
                            ),
                            (protected) => false,
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigatorScreen(),
                            ),
                            (protected) => false,
                          );
                        }
                      } else {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url: AppConfig.termOfUse,
                          title: "Terms of Use",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Terms of Use',
                    style: AppTextStyles.s15W400(
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                Container(
                  height: 10,
                  width: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                InkWell(
                  onTap: () {},
                  // => CheckRestore.checkRestore(context),
                  child: Text(
                    'Restore',
                    style: AppTextStyles.s15W400(
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                Container(
                  height: 10,
                  width: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url: AppConfig.privacyPolicy,
                          title: "Privacy Policy",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Privacy Policy',
                    style: AppTextStyles.s15W400(
                        color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
