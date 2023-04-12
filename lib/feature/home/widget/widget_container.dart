import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/home/detail_home_screen.dart';
import 'package:on_retouch/logic/model/life_hack_model.dart';
import 'package:shimmer/shimmer.dart';

class WidgetContainer extends StatelessWidget {
  const WidgetContainer({Key? key, required this.model}) : super(key: key);
  final LifehackModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailHomeScreen(
              model: model,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: model.image,
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
                    image: NetworkImage(model.image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            model.title,
            style: AppTextStyles.s16W400(color: Colors.black),
          )
        ],
      ),
    );
  }
}
