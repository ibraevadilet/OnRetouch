import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/settings/detail_my_projetc_screen.dart';

import 'package:shimmer/shimmer.dart';

class WidgetPhotoContainer extends StatefulWidget {
  const WidgetPhotoContainer({
    Key? key,
  }) : super(key: key);
  // final ImageModel model;

  @override
  State<WidgetPhotoContainer> createState() => _WidgetPhotoContainerState();
}

class _WidgetPhotoContainerState extends State<WidgetPhotoContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailMyProjectScreen(),
          ),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: "https://autodmir.ru/logo/1/2312/photo.jpg",
              placeholder: (_, url) {
                return SizedBox(
                  height: 172,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.4),
                    highlightColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
              imageBuilder: (_, imageProvider) {
                return Container(
                  alignment: Alignment.topRight,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                  style: AppTextStyles.s12W400(color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
