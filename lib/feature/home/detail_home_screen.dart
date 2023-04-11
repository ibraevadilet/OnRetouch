import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:shimmer/shimmer.dart';

class DetailHomeScreen extends StatelessWidget {
  const DetailHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Lifehacks",
          style: AppTextStyles.s24W500(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: "https://autodmir.ru/logo/1/2312/photo.jpg",
              placeholder: (_, url) {
                return SizedBox(
                  height: 250,
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
                  height: 250,
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
            const SizedBox(height: 25),
            Text(
              "How to do dark photo editing?",
              style: AppTextStyles.s20W500(color: Colors.black),
            ),
            const SizedBox(height: 25),
            Text(
              "Contrast - 25 Brightnes",
              style: AppTextStyles.s16W400(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
