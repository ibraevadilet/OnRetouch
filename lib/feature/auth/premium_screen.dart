import 'package:flutter/material.dart';
import 'package:on_retouch/config/app_config.dart';
import 'package:on_retouch/config/check_premium.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/web_view_screen.dart';
import 'package:on_retouch/widgets/buttom_navigator.dart';
import 'package:on_retouch/widgets/custom_button.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key, this.isPop = false});
  final bool isPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.color38B6FFBlue,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (isPop) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavigatorScreen(),
                          ),
                          (protected) => false,
                        );
                      }
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Become a Premium',
                style: AppTextStyles.s32W800(color: Colors.white),
              ),
              const Spacer(),
              Image.asset(AppImages.premiumImage),
              const Spacer(),
              Row(children: [
                Image.asset(AppImages.crownGoldIcon, width: 20),
                const SizedBox(width: 10),
                Text('Without adds',
                    style: AppTextStyles.s24W600(color: Colors.white))
              ]),
              const SizedBox(height: 15),
              Row(children: [
                Image.asset(AppImages.crownGoldIcon, width: 20),
                const SizedBox(width: 10),
                Text('Access to all tools',
                    style: AppTextStyles.s24W600(color: Colors.white))
              ]),
              const SizedBox(height: 15),
              Row(children: [
                Image.asset(AppImages.crownGoldIcon, width: 20),
                const SizedBox(width: 10),
                Text('Access to all filters',
                    style: AppTextStyles.s24W600(color: Colors.white))
              ]),
              const Spacer(),
              CustomButton(
                color: Colors.white,
                icon: AppImages.crownGoldIcon,
                text: 'Buy Premium for \$1.99',
                textColor: AppColors.color38B6FFBlue,
                onPressed: () async {
                  await CheckPremium.setSubscription();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavigatorScreen(),
                    ),
                    (protected) => false,
                  );
                },
              ),
              const Spacer(),
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
        ));
  }
}