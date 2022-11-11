import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paging/domain/model/list_item.dart';

part 'main_state.freezed.dart';

part 'main_state.g.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isLoading,
    @Default([]) List<ListItem> items,
    String? error,
    @Default(false) bool endReached,
    @Default(0) int page,
  }) = _MainState;

  factory MainState.fromJson(Map<String, Object?> json) => _$MainStateFromJson(json);
}