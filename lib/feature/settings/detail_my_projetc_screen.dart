import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/logic/model/image_model.dart';
import 'package:share_plus/share_plus.dart';

class DetailMyProjectScreen extends StatelessWidget {
  const DetailMyProjectScreen({Key? key, required this.model})
      : super(key: key);
  final ImageModel model;

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
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: model.image,
            ),
            const SizedBox(height: 25),
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
      ),
    );
  }
}
