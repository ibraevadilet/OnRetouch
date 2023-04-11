part of 'save_image_cubit.dart';

@freezed
class SaveImageState with _$SaveImageState {
  const factory SaveImageState.initial() = _Initial;
  const factory SaveImageState.loading() = _Loading;
  const factory SaveImageState.error(String error) = _Error;
  const factory SaveImageState.success() = _Success;

  const SaveImageState._();
  bool get isLoading => maybeWhen(
        orElse: () => false,
        loading: () => true,
      );
}
