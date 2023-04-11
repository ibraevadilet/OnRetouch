import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/settings/widget/widget_photo_container.dart';

class MyProjectScreen extends StatelessWidget {
  const MyProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "My projects",
          style: AppTextStyles.s24W500(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 10,
            mainAxisExtent: 205,
          ),
          itemBuilder: (context, index) => WidgetPhotoContainer(),
          itemCount: 4,
        ),
      ),
    );
  }
}
