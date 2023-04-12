import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/settings/widget/widget_photo_container.dart';
import 'package:on_retouch/logic/get_pictures_cubit/get_pictures_cubit.dart';
import 'package:on_retouch/widgets/app_error_text.dart';
import 'package:on_retouch/widgets/app_indicator.dart';

class MyProjectScreen extends StatelessWidget {
  const MyProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPicturesCubit()..getPictures(),
      child: Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<GetPicturesCubit, GetPicturesState>(
            builder: (context, state) {
              return state.when(
                initial: () => const AppIndicator(),
                loading: () => const AppIndicator(),
                failed: (error) => AppErrorText(error: error),
                success: (model) => model.isEmpty
                    ? Center(
                        child: Text(
                          "You haven't created yet",
                          style: AppTextStyles.s19W700(),
                        ),
                      )
                    : GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 205,
                        ),
                        itemBuilder: (context, index) => WidgetPhotoContainer(
                          model: model[index],
                        ),
                        itemCount: model.length,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
