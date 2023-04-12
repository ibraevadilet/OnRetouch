import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_retouch/core/app_text_styles.dart';
import 'package:on_retouch/feature/home/widget/widget_container.dart';
import 'package:on_retouch/logic/get_life_hacks_cubit/get_life_hacks_cubit.dart';
import 'package:on_retouch/widgets/app_error_text.dart';
import 'package:on_retouch/widgets/app_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetLifeHacksCubit()..getLifeHacks(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Lifehacks',
                  style: AppTextStyles.s24W500(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<GetLifeHacksCubit, GetLifeHacksState>(
                    builder: (context, state) {
                      return state.when(
                        loading: () => const AppIndicator(),
                        error: (error) => AppErrorText(error: error),
                        success: (model) => ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => WidgetContainer(
                            model: model[index],
                          ),
                          separatorBuilder: (context, index) => Column(
                            children: const [
                              SizedBox(height: 20),
                              Divider(
                                color: Colors.black,
                                height: 1,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                          itemCount: model.length,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
