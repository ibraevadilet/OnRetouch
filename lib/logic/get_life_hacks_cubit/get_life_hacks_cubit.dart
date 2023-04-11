import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_retouch/logic/model/life_hack_model.dart';

part 'get_life_hacks_state.dart';
part 'get_life_hacks_cubit.freezed.dart';

class GetLifeHacksCubit extends Cubit<GetLifeHacksState> {
  GetLifeHacksCubit() : super(const GetLifeHacksState.loading());

  Future<List<LifehackModel>> getLifeHacks() async {
    emit(const GetLifeHacksState.loading());
    try {
      final lifeHacks = await getLifeHacksFromServer();

      emit(GetLifeHacksState.success(lifeHacks));
      return lifeHacks;
    } catch (e) {
      emit(GetLifeHacksState.error(e.toString()));
      return [];
    }
  }

  Future<List<LifehackModel>> getLifeHacksFromServer() async {
    final snapshot = await FirebaseDatabase.instance.ref('lifehacks').get();

    final lifeHacksFromServer = <LifehackModel>[];
    if (snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        value['id'] = key;
        final lesson = LifehackModel.fromJson(value);

        lifeHacksFromServer.add(lesson);
      });
    }

    return lifeHacksFromServer;
  }
}
