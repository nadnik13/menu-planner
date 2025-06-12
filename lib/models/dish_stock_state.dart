import 'package:freezed_annotation/freezed_annotation.dart';
import 'dish_stock.dart';

part 'dish_stock_state.freezed.dart';

@freezed
class DishStockState with _$DishStockState {
  const factory DishStockState.initial() = _Initial;
  const factory DishStockState.loading() = _Loading;
  const factory DishStockState.loaded(Set<DishStock> stocks) = _Loaded;
  const factory DishStockState.error(String message) = _Error;
} 