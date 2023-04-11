import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:shimmer/shimmer.dart';

class DetailMyProjectScreen extends StatelessWidget {
  const DetailMyProjectScreen({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: "https://autodmir.ru/logo/1/2312/photo.jpg",
              placeholder: (_, url) {
                return SizedBox(
                  height: 500,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.4),
                    highlightColor: Colors.white,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              imageBuilder: (_, imageProvider) {
                return Container(
                  alignment: Alignment.topRight,
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://autodmir.ru/logo/1/2312/photo.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Image.asset(
                  AppImages.dateIcon,
                  width: 15,
                ),
                const SizedBox(width: 10),
                Text(
                  "21.03.2023",
                  style: AppTextStyles.s14W400(color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
