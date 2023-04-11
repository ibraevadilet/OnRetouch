import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/home/widget/widget_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                  'Lifehacks',
                  style: AppTextStyles.s24W500(
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => WidgetContainer(),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                    ),
                    itemCount: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
