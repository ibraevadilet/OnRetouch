import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_retouch/core/app_images.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/image_editor/image_editor_plus.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Studio',
                  style: AppTextStyles.s24W500(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    "Import an image from the \ngallery to get started",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.s20W400(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? imageFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (imageFile != null) {
                      Uint8List imageData =
                          File(imageFile.path).readAsBytesSync();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageEditor(
                            image: imageData,
                          ),
                        ),
                      );
                    }
                  },
                  child: Center(
                      child: Image.asset(
                    AppImages.addIcon,
                    width: 50,
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
