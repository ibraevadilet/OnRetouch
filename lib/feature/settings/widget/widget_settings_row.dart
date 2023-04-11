import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';

class WidgetSettingsRow extends StatelessWidget {
  const WidgetSettingsRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String icon;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                icon,
                width: 20,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: AppTextStyles.s15W400(color: Colors.black),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
