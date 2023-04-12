import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/settings/detail_my_projetc_screen.dart';
import 'package:on_retouch/logic/model/image_model.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shimmer/shimmer.dart';

class WidgetPhotoContainer extends StatelessWidget {
  const WidgetPhotoContainer({
    Key? key,
    required this.model,
  }) : super(key: key);
  final ImageModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMyProjectScreen(
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
                height: 175,
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
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(model.image),
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
                model.date,
                style: AppTextStyles.s12W400(color: Colors.grey),
              ),
              const Spacer(),
              PopupMenuButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        Share.share(model.image);
                      },
                      child: Row(
                        children: [
                          const Text('Share image'),
                          const Spacer(),
                          Image.asset('assets/images/share_icon.png'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await ImageDownloader.downloadImage(
                          model.image,
                        );
                      },
                      child: Row(
                        children: [
                          const Text('Download image'),
                          const Spacer(),
                          Image.asset('assets/images/download_icon.png'),
                        ],
                      ),
                    ),
                  ];
                },
                child: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
