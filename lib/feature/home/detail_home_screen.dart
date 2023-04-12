import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/logic/model/life_hack_model.dart';
import 'package:shimmer/shimmer.dart';

class DetailHomeScreen extends StatelessWidget {
  const DetailHomeScreen({Key? key, required this.model}) : super(key: key);
  final LifehackModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Lifehacks",
          style: AppTextStyles.s24W500(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 25),
            Text(
              model.title,
              style: AppTextStyles.s20W500(color: Colors.black),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListView.separated(
                  itemBuilder: (context, index) => Text(
                    model.descriptionTexts[index],
                    style: AppTextStyles.s16W400(color: Colors.black),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: model.descriptionTexts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
