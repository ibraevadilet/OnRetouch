import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_retouch/core/local_db.dart';
import 'package:on_retouch/logic/model/image_model.dart';

part 'get_pictures_cubit.freezed.dart';

class GetPicturesCubit extends Cubit<GetPicturesState> {
  GetPicturesCubit() : super(const GetPicturesState.initial());

  Future<List<ImageModel>> getPictures() async {
    emit(const GetPicturesState.loading());
    try {
      final uid = await SavedData.getUserId();
      final pictures = await getPicturesFromServer();
      pictures.removeWhere((e) => e.uid != uid);
      emit(GetPicturesState.success(pictures));
      return pictures;
    } catch (e) {
      emit(GetPicturesState.failed(e.toString()));
      return [];
    }
  }

  Future<List<ImageModel>> getPicturesFromServer() async {
    final snapshot = await FirebaseDatabase.instance.ref('images').get();

    final lessonsFromServer = <ImageModel>[];
    if (snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        value['id'] = key;
        final lesson = ImageModel.fromJson(value);

        lessonsFromServer.add(lesson);
      });
    }

    return lessonsFromServer;
  }
}

@freezed
class GetPicturesState with _$GetPicturesState {
  const factory GetPicturesState.initial() = _Initial;
  const factory GetPicturesState.loading() = _Loading;
  const factory GetPicturesState.success(List<ImageModel> pictures) = _Success;
  const factory GetPicturesState.failed(String message) = _Failed;
}
