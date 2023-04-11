import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/home/detail_home_screen.dart';
import 'package:shimmer/shimmer.dart';

class WidgetContainer extends StatelessWidget {
  const WidgetContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailHomeScreen(),
          ),
        );
      },
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
          const SizedBox(height: 20),
          Text(
            "How to achieve this effect on the photo?",
            style: AppTextStyles.s16W400(color: Colors.black),
          )
        ],
      ),
    );
  }
}
