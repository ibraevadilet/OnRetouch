import 'package:flutter/material.dart';
import 'package:on_retouch/utils/premium.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/auth/premium_screen.dart';
import 'package:on_retouch/feature/settings/my_projects_screen.dart';
import 'package:on_retouch/feature/settings/widget/widget_settings_row.dart';
import 'package:on_retouch/web_view_screen.dart';

import '../../utils/restore.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Settings',
                style: AppTextStyles.s24W500(
                  color: Colors.black,
                ),
              ),
              WidgetSettingsRow(
                  icon: AppImages.myProjectsIcon,
                  text: "My projects",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProjectScreen(),
                      ),
                    );
                  }),
              WidgetSettingsRow(
                icon: AppImages.privacyIcon,
                text: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        url: 'https://docs.google.com/document/d/1bmaoQUFPZBEUqiW5t_YEhKNSTwAW022raTSLLI_vFas/edit?usp=sharing',
                        title: "Privacy Policy",
                      ),
                    ),
                  );
                },
              ),
              WidgetSettingsRow(
                icon: AppImages.termsIcon,
                text: 'Terms of Use',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        url: 'https://docs.google.com/document/d/1z63Obg6SwXDoWxrTDLUGSDxRDAF7oo-4yEehbJEJ5vQ/edit?usp=sharing',
                        title: "Terms of Use",
                      ),
                    ),
                  );
                },
              ),
              WidgetSettingsRow(
                icon: AppImages.supportIcon,
                text: 'Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        url: 'https://sites.google.com/view/onretouch/contact-us',
                        title: "Support",
                      ),
                    ),
                  );
                },
              ),
              WidgetSettingsRow(
                icon: AppImages.restoreIcon,
                text: 'Restore',
                onTap: () => CheckRestore.checkRestore(context),
              ),
              const SizedBox(height: 25),
              FutureBuilder(
                future: CheckPremium.getSubscription(),
                builder: (context, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!) {
                      return const SizedBox();
                    }
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PremiumScreen(isPop: true),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: AppColors.color38B6FFBlue,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Image.asset(
                            AppImages.crownGoldIcon,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Buy Premium for \$1.99",
                            style: AppTextStyles.s15W400(color: Colors.white),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
