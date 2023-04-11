import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({
    super.key,
    required this.title,
    required this.image,
  });
  final String title;

  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.start,
          style: AppTextStyles.s32W800(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 45),
        Image.asset(image),
        const Spacer(),
      ],
    );
  }
}
