import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:colorfilter_generator/presets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hand_signature/signature.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart' as image_editor;
import 'package:on_retouch/utils/premium.dart';
import 'package:on_retouch/core/app_colors.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/auth/premium_screen.dart';
import 'package:on_retouch/feature/image_editor/data/layer.dart';
import 'package:on_retouch/widgets/buttom_navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_retouch/core/local_db.dart';
import 'package:on_retouch/feature/image_editor/data/image_item.dart';
import 'package:on_retouch/feature/image_editor/layers/background_blur_layer.dart';
import 'package:on_retouch/feature/image_editor/layers/background_layer.dart';
import 'package:on_retouch/feature/image_editor/layers/emoji_layer.dart';
import 'package:on_retouch/feature/image_editor/layers/image_layer.dart';
import 'package:on_retouch/feature/image_editor/layers/text_layer.dart';
import 'package:on_retouch/feature/image_editor/modules/all_emojies.dart';
import 'package:on_retouch/feature/image_editor/modules/text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_retouch/logic/save_image_cubit/save_image_cubit.dart';
import 'package:on_retouch/widgets/app_indicator.dart';
import 'package:on_retouch/widgets/styled_toasts.dart';
import 'package:screenshot/screenshot.dart';

import 'modules/colors_picker.dart';

late Size viewportSize;
double viewportRatio = 1;

List<Layer> layers = [], undoLayers = [], removedLayers = [];
Map<String, String> _translations = {};

String i18n(String sourceString) =>
    _translations[sourceString.toLowerCase()] ?? sourceString;

/// Single endpoint for MultiImageEditor & SingleImageEditor
class ImageEditor extends StatelessWidget {
  final Uint8List? image;

  final Directory? savePath;
  final int maxLength;

  const ImageEditor(
      {Key? key, this.image, this.savePath, this.maxLength = 99, Color? appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleImageEditor(
      image: image,
    );
  }

  static i18n(Map<String, String> translations) {
    translations.forEach((key, value) {
      _translations[key.toLowerCase()] = value;
    });
  }
}

class SingleImageEditor extends StatefulWidget {
  final dynamic image;

  const SingleImageEditor({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  createState() => _SingleImageEditorState();
}

class _SingleImageEditorState extends State<SingleImageEditor> {
  ImageItem currentImage = ImageItem();

  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    layers.clear();
    super.dispose();
  }

  Future<String> onSave() async {
    String pathh = '';
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }

    if (isGranted) {
      final result = await screenshotController.capture();
      if (result != null) {
        final tempDir = await getTemporaryDirectory();
        File file =
            await File('${tempDir.path}/${DateTime.now()}.png').create();
        file.writeAsBytesSync(result);
        await GallerySaver.saveImage(file.path);
        pathh = file.path;
      }
    }
    return pathh;
  }

  List<Widget> get filterActions {
    return [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      const Spacer(),
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        icon: Icon(Icons.undo,
            color: layers.length > 1 || removedLayers.isNotEmpty
                ? AppColors.color38B6FFBlue
                : Colors.grey),
        onPressed: () {
          if (removedLayers.isNotEmpty) {
            layers.add(removedLayers.removeLast());
            setState(() {});
            return;
          }

          if (layers.length <= 1) return; // do not remove image layer

          undoLayers.add(layers.removeLast());

          setState(() {});
        },
      ),
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        icon: Icon(Icons.redo,
            color: undoLayers.isNotEmpty
                ? AppColors.color38B6FFBlue
                : Colors.grey),
        onPressed: () {
          if (undoLayers.isEmpty) return;

          layers.add(undoLayers.removeLast());

          setState(() {});
        },
      ),
      BlocConsumer<SaveImageCubit, SaveImageState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              showSuccessSnackBar('Saved');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavigatorScreen(),
                ),
                (protected) => false,
              );
            },
          );
        },
        builder: (context, state) {
          return state.isLoading
              ? const AppIndicator(
                  color: AppColors.color38B6FFBlue,
                )
              : IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  icon: Text(
                    'Save',
                    style: AppTextStyles.s15W600(
                      color: AppColors.color38B6FFBlue,
                    ),
                  ),
                  onPressed: () async {
                    final uid = await SavedData.getUserId();
                    if (uid.isEmpty) {
                      await SavedData.setUserId();
                    }
                    final image = await onSave();
                    context.read<SaveImageCubit>().saveImage(image);
                  },
                );
        },
      ),
      const SizedBox(width: 10)
    ];
  }

  @override
  void initState() {
    if (widget.image != null) {
      loadImage(widget.image!);
    }

    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;

  double x = 0;
  double y = 0;
  double z = 0;

  double lastScaleFactor = 1, scaleFactor = 1;
  double widthRatio = 1, heightRatio = 1, pixelRatio = 1;

  resetTransformation() {
    scaleFactor = 1;
    x = 0;
    y = 0;
    setState(() {});
  }

  /// obtain image Uint8List by merging layers
  Future<Uint8List?> getMergedImage() async {
    if (layers.length == 1 && layers.first is BackgroundLayerData) {
      return (layers.first as BackgroundLayerData).file.image;
    } else if (layers.length == 1 && layers.first is ImageLayerData) {
      return (layers.first as ImageLayerData).image.image;
    }

    return screenshotController.capture(
      pixelRatio: pixelRatio,
    );
  }

  @override
  Widget build(BuildContext context) {
    viewportSize = MediaQuery.of(context).size;

    var layersStack = Stack(
      children: layers.map((layerItem) {
        // Background layer
        if (layerItem is BackgroundLayerData) {
          return BackgroundLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }

        // Image layer
        if (layerItem is ImageLayerData) {
          return ImageLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }

        // Background blur layer
        if (layerItem is BackgroundBlurLayerData && layerItem.radius > 0) {
          return BackgroundBlurLayer(
            layerData: layerItem,
          );
        }

        // Emoji layer
        if (layerItem is EmojiLayerData) {
          return EmojiLayer(layerData: layerItem);
        }

        // Text layer
        if (layerItem is TextLayerData) {
          return TextLayer(
            layerData: layerItem,
            onUpdate: () {
              setState(() {});
            },
          );
        }

        // Blank layer
        return Container();
      }).toList(),
    );

    widthRatio = currentImage.width / viewportSize.width;
    heightRatio = currentImage.height / viewportSize.height;
    pixelRatio = math.max(heightRatio, widthRatio);

    return BlocProvider(
      create: (context) => SaveImageCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaf,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: filterActions,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onScaleUpdate: (details) {
            // print(details);

            // move
            if (details.pointerCount == 1) {
              // print(details.focalPointDelta);
              x += details.focalPointDelta.dx;
              y += details.focalPointDelta.dy;
              setState(() {});
            }

            // scale
            if (details.pointerCount == 2) {
              // print([details.horizontalScale, details.verticalScale]);
              if (details.horizontalScale != 1) {
                scaleFactor = lastScaleFactor *
                    math.min(details.horizontalScale, details.verticalScale);
                setState(() {});
              }
            }
          },
          onScaleEnd: (details) {
            lastScaleFactor = scaleFactor;
          },
          child: Center(
            child: SizedBox(
              height: currentImage.height / pixelRatio,
              width: currentImage.width / pixelRatio,
              child: Screenshot(
                controller: screenshotController,
                child: RotatedBox(
                  quarterTurns: rotateValue,
                  child: Transform(
                    transform: Matrix4(
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                      x,
                      y,
                      0,
                      1 / scaleFactor,
                    )..rotateY(flipValue),
                    alignment: FractionalOffset.center,
                    child: layersStack,
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 86 + MediaQuery.of(context).padding.bottom,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.color38B6FFBlue,
            shape: BoxShape.rectangle,
          ),
          child: SafeArea(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                const SizedBox(width: 15),
                BottomButton(
                  icon: Icons.crop,
                  text: 'Crop',
                  onTap: () async {
                    resetTransformation();

                    var mergedImage = await getMergedImage();

                    Uint8List? croppedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageCropper(
                          image: mergedImage!,
                        ),
                      ),
                    );

                    if (croppedImage == null) return;

                    flipValue = 0;
                    rotateValue = 0;

                    await currentImage.load(croppedImage);
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.text_fields,
                  text: 'Text',
                  onTap: () async {
                    final isBuy = await CheckPremium.getSubscription();
                    if (!isBuy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(
                            isPop: true,
                          ),
                        ),
                      );
                    } else {
                      TextLayerData? layer = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TextEditorImage(),
                        ),
                      );

                      if (layer == null) return;

                      undoLayers.clear();
                      removedLayers.clear();

                      layers.add(layer);

                      setState(() {});
                    }
                  },
                ),
                BottomButton(
                  icon: Icons.flip,
                  text: 'Flip',
                  onTap: () {
                    setState(() {
                      flipValue = flipValue == 0 ? math.pi : 0;
                    });
                  },
                ),
                BottomButton(
                  icon: Icons.rotate_left,
                  text: 'Rotate left',
                  onTap: () {
                    var t = currentImage.width;
                    currentImage.width = currentImage.height;
                    currentImage.height = t;

                    rotateValue--;
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.rotate_right,
                  text: 'Rotate right',
                  onTap: () {
                    var t = currentImage.width;
                    currentImage.width = currentImage.height;
                    currentImage.height = t;

                    rotateValue++;
                    setState(() {});
                  },
                ),
                BottomButton(
                  icon: Icons.blur_on,
                  text: 'Blur',
                  onTap: () {
                    var blurLayer = BackgroundBlurLayerData(
                      color: Colors.transparent,
                      radius: 0.0,
                      opacity: 0.0,
                    );

                    undoLayers.clear();
                    removedLayers.clear();
                    layers.add(blurLayer);
                    setState(() {});

                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setS) {
                            return SingleChildScrollView(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                ),
                                padding: const EdgeInsets.all(20),
                                height: 400,
                                child: Column(
                                  children: [
                                    Center(
                                        child: Text(
                                      i18n('Slider Filter Color').toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                    const Divider(),
                                    const SizedBox(height: 20.0),
                                    Text(
                                      i18n('Slider Color'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      Expanded(
                                        child: BarColorPicker(
                                          width: 300,
                                          thumbColor: Colors.white,
                                          cornerRadius: 10,
                                          pickMode: PickMode.color,
                                          colorListener: (int value) {
                                            setS(() {
                                              setState(() {
                                                blurLayer.color = Color(value);
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          i18n('Reset'),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            setS(() {
                                              blurLayer.color =
                                                  Colors.transparent;
                                            });
                                          });
                                        },
                                      )
                                    ]),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      i18n('Blur Radius'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(children: [
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: blurLayer.radius,
                                          min: 0.0,
                                          max: 10.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                blurLayer.radius = v;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          i18n('Reset'),
                                        ),
                                        onPressed: () {
                                          setS(() {
                                            setState(() {
                                              blurLayer.color = Colors.white;
                                            });
                                          });
                                        },
                                      )
                                    ]),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      i18n('Color Opacity'),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(children: [
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.white,
                                          inactiveColor: Colors.grey,
                                          value: blurLayer.opacity,
                                          min: 0.00,
                                          max: 1.0,
                                          onChanged: (v) {
                                            setS(() {
                                              setState(() {
                                                blurLayer.opacity = v;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          i18n('Reset'),
                                        ),
                                        onPressed: () {
                                          setS(() {
                                            setState(() {
                                              blurLayer.opacity = 0.0;
                                            });
                                          });
                                        },
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                BottomButton(
                  icon: Icons.photo,
                  text: 'Filter',
                  onTap: () async {
                    final isBuy = await CheckPremium.getSubscription();
                    if (!isBuy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(
                            isPop: true,
                          ),
                        ),
                      );
                    } else {
                      resetTransformation();

                      var mergedImage = await getMergedImage();

                      Uint8List? filterAppliedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageFilters(
                            image: mergedImage!,
                          ),
                        ),
                      );

                      if (filterAppliedImage == null) return;

                      removedLayers.clear();
                      undoLayers.clear();

                      var layer = BackgroundLayerData(
                        file: ImageItem(filterAppliedImage),
                      );

                      /// Use case, if you don't want your filter to effect your
                      /// other elements such as emoji and text. Use insert
                      /// instead of add like in line 888
                      //layers.insert(1, layer);
                      layers.add(layer);

                      await layer.file.status;

                      setState(() {});
                    }
                  },
                ),
                BottomButton(
                  icon: FontAwesomeIcons.faceSmile,
                  text: 'Emoji',
                  onTap: () async {
                    final isBuy = await CheckPremium.getSubscription();
                    if (!isBuy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(
                            isPop: true,
                          ),
                        ),
                      );
                    } else {
                      EmojiLayerData? layer = await showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black,
                        builder: (BuildContext context) {
                          return const Emojies();
                        },
                      );

                      if (layer == null) return;

                      undoLayers.clear();
                      removedLayers.clear();
                      layers.add(layer);

                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  Future<void> loadImage(dynamic imageFile) async {
    await currentImage.load(imageFile);

    layers.clear();

    layers.add(BackgroundLayerData(
      file: currentImage,
    ));

    setState(() {});
  }
}

/// Button used in bottomNavigationBar in ImageEditor
class BottomButton extends StatelessWidget {
  final VoidCallback? onTap, onLongPress;
  final IconData icon;
  final String text;

  const BottomButton({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}

/// Crop given image with various aspect ratios
class ImageCropper extends StatefulWidget {
  final Uint8List image;

  const ImageCropper({Key? key, required this.image}) : super(key: key);

  @override
  createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> _controller =
      GlobalKey<ExtendedImageEditorState>();

  double? aspectRatio;
  double? aspectRatioOriginal;
  bool isLandscape = true;
  int rotateAngle = 0;

  @override
  void initState() {
    _controller.currentState?.rotate(right: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.currentState != null) {
      // _controller.currentState?.
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            icon: Text(
              'Next',
              style: AppTextStyles.s15W600(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              var state = _controller.currentState;

              if (state == null) return;

              var data = await cropImageDataWithNativeLibrary(state: state);

              Navigator.pop(context, data);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ExtendedImage.memory(
          widget.image,
          cacheRawData: true,
          fit: BoxFit.contain,
          extendedImageEditorKey: _controller,
          mode: ExtendedImageMode.editor,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              cropAspectRatio: aspectRatio,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.color38B6FFBlue,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    imageRatioButton(null, 'Freeform'),
                    imageRatioButton(1, 'Square'),
                    imageRatioButton(4 / 3, '4:3'),
                    imageRatioButton(5 / 4, '5:4'),
                    imageRatioButton(7 / 5, '7:5'),
                    imageRatioButton(16 / 9, '16:9'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    final Rect? cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction!;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final image_editor.ImageEditorOption option =
        image_editor.ImageEditorOption();

    if (action.needCrop) {
      option.addOption(image_editor.ClipOption.fromRect(cropRect!));
    }

    if (action.needFlip) {
      option.addOption(image_editor.FlipOption(
          horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(image_editor.RotateOption(rotateAngle));
    }

    // final DateTime start = DateTime.now();
    final Uint8List? result = await image_editor.ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    // print('${DateTime.now().difference(start)} ：total time');

    return result;
  }

  Widget imageRatioButton(double? ratio, String title) {
    return TextButton(
      onPressed: () {
        aspectRatioOriginal = ratio;
        if (aspectRatioOriginal != null && isLandscape == false) {
          aspectRatio = 1 / aspectRatioOriginal!;
        } else {
          aspectRatio = aspectRatioOriginal;
        }
        setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            i18n(title),
            style: TextStyle(
              color: aspectRatioOriginal == ratio ? Colors.white : Colors.black,
            ),
          )),
    );
  }
}

/// Return filter applied Uint8List image
class ImageFilters extends StatefulWidget {
  final Uint8List image;

  /// apply each filter to given image in background and cache it to improve UX
  final bool useCache;

  const ImageFilters({
    Key? key,
    required this.image,
    this.useCache = true,
  }) : super(key: key);

  @override
  createState() => _ImageFiltersState();
}

class _ImageFiltersState extends State<ImageFilters> {
  late img.Image decodedImage;
  ColorFilterGenerator selectedFilter = PresetFilters.none;
  Uint8List resizedImage = Uint8List.fromList([]);
  double filterOpacity = 1;
  Uint8List filterAppliedImage = Uint8List.fromList([]);
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // decodedImage = img.decodeImage(widget.image)!;
    // resizedImage = img.copyResize(decodedImage, height: 64).getBytes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            icon: Text(
              'Next',
              style: AppTextStyles.s15W600(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              var data = await screenshotController.capture();
              Navigator.pop(context, data);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Image.memory(
                widget.image,
                fit: BoxFit.cover,
              ),
              FilterAppliedImage(
                image: widget.image,
                filter: selectedFilter,
                fit: BoxFit.cover,
                opacity: filterOpacity,
                onProcess: (img) {
                  // print('processing done');
                  filterAppliedImage = img;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 160,
          child: Column(children: [
            SizedBox(
              height: 40,
              child: selectedFilter == PresetFilters.none
                  ? Container()
                  : selectedFilter.build(
                      Slider(
                        min: 0,
                        max: 1,
                        divisions: 100,
                        value: filterOpacity,
                        onChanged: (value) {
                          filterOpacity = value;
                          setState(() {});
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < presetFiltersList.length; i++)
                    filterPreviewButton(
                      filter: presetFiltersList[i],
                      name: presetFiltersList[i].name,
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget filterPreviewButton({required filter, required String name}) {
    return GestureDetector(
      onTap: () {
        selectedFilter = filter;
        setState(() {});
      },
      child: Column(children: [
        Container(
          height: 64,
          width: 64,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: FilterAppliedImage(
              image: widget.image,
              filter: filter,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          i18n(name),
          style: const TextStyle(fontSize: 12),
        ),
      ]),
    );
  }
}

/// Short form of Image.memory wrapped in ColorFiltered
class FilterAppliedImage extends StatelessWidget {
  final Uint8List image;
  final ColorFilterGenerator filter;
  final BoxFit? fit;
  final Function(Uint8List)? onProcess;
  final double opacity;

  FilterAppliedImage({
    Key? key,
    required this.image,
    required this.filter,
    this.fit,
    this.onProcess,
    this.opacity = 1,
  }) : super(key: key) {
    // process filter in background
    if (onProcess != null) {
      // no filter supplied
      if (filter.filters.isEmpty) {
        onProcess!(image);
        return;
      }

      final image_editor.ImageEditorOption option =
          image_editor.ImageEditorOption();

      option.addOption(image_editor.ColorOption(matrix: filter.matrix));

      image_editor.ImageEditor.editImage(
        image: image,
        imageEditorOption: option,
      ).then((result) {
        if (result != null) {
          onProcess!(result);
        }
      }).catchError((err, stack) {
        // print(err);
        // print(stack);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filter.filters.isEmpty) return Image.memory(image, fit: fit);

    return Opacity(
      opacity: opacity,
      child: filter.build(
        Image.memory(image, fit: fit),
      ),
    );
  }
}

/// Show image drawing surface over image
class ImageEditorDrawing extends StatefulWidget {
  final Uint8List image;

  const ImageEditorDrawing({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ImageEditorDrawing> createState() => _ImageEditorDrawingState();
}

class _ImageEditorDrawingState extends State<ImageEditorDrawing> {
  ImageItem image = ImageItem();

  Color pickerColor = Colors.white;
  Color currentColor = Colors.white;

  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  List<CubicPath> undoList = [];
  bool skipNextEvent = false;

  List<Color> colorList = [
    Colors.black,
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.brown,
    Colors.indigo,
    Colors.indigo,
  ];

  void changeColor(Color color) {
    currentColor = color;
    setState(() {});
  }

  @override
  void initState() {
    image.load(widget.image);
    control.addListener(() {
      if (control.hasActivePath) return;

      if (skipNextEvent) {
        skipNextEvent = false;
        return;
      }

      undoList = [];
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: Icon(
              Icons.undo,
              color: control.paths.isNotEmpty
                  ? Colors.white
                  : Colors.white.withAlpha(80),
            ),
            onPressed: () {
              if (control.paths.isEmpty) return;
              skipNextEvent = true;
              undoList.add(control.paths.last);
              control.stepBack();
              setState(() {});
            },
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: Icon(
              Icons.redo,
              color: undoList.isNotEmpty
                  ? Colors.white
                  : Colors.white.withAlpha(80),
            ),
            onPressed: () {
              if (undoList.isEmpty) return;

              control.paths.add(undoList.removeLast());
              setState(() {});
            },
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (control.paths.isEmpty) return Navigator.pop(context);
              var data = await control.toImage(color: currentColor);

              return Navigator.pop(context, data!.buffer.asUint8List());
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: currentColor == Colors.black ? Colors.white : Colors.black,
          image: DecorationImage(
            image: Image.memory(widget.image).image,
            fit: BoxFit.contain,
          ),
        ),
        child: HandSignature(
          control: control,
          color: currentColor,
          width: 1.0,
          maxWidth: 10.0,
          type: SignatureDrawType.shape,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 2),
            ],
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ColorButton(
                color: Colors.yellow,
                onTap: (color) {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.black87,
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.only(top: 16),
                            child: HueRingPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              for (int i = 0; i < colorList.length; i++)
                ColorButton(
                  color: colorList[i],
                  onTap: (color) => changeColor(color),
                  isSelected: colorList[i] == currentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button used in bottomNavigationBar in ImageEditorDrawing
class ColorButton extends StatelessWidget {
  final Color color;
  final Function onTap;
  final bool isSelected;

  const ColorButton({
    Key? key,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(color);
      },
      child: Container(
        height: 34,
        width: 34,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 23),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white54,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
