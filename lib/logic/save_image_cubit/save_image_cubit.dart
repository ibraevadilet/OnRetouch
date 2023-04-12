import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_retouch/core/date_formats.dart';
import 'package:on_retouch/core/local_db.dart';
import 'package:on_retouch/logic/model/image_model.dart';

part 'save_image_state.dart';
part 'save_image_cubit.freezed.dart';

class SaveImageCubit extends Cubit<SaveImageState> {
  SaveImageCubit() : super(const SaveImageState.initial());
  final postsDataBase = FirebaseDatabase.instance.ref('images');

  saveImage(String image) async {
    emit(const SaveImageState.loading());
    final uid = await SavedData.getUserId();
    String url = await uploadImage(File(image));
    final String date = dayMonthYearByDot.format(DateTime.now());
    await postsDataBase.push().set(ImageModel(
          image: url,
          uid: uid.toString(),
          date: date,
        ).toJson());
    emit(const SaveImageState.success());
  }

  Future<String> uploadImage(File file) async {
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();

    Reference ref = storageRef
        .child('pictures/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metadata);
    final taskSnapshot = await uploadTask.whenComplete(() => null);

    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
