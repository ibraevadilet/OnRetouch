part of 'get_life_hacks_cubit.dart';

@freezed
class GetLifeHacksState with _$GetLifeHacksState {
  const factory GetLifeHacksState.loading() = _Loading;
  const factory GetLifeHacksState.error(String error) = _Error;
  const factory GetLifeHacksState.success(List<LifehackModel> model) = _Success;
}
