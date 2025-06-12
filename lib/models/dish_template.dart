import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'dish_template.freezed.dart';
part 'dish_template.g.dart';

@freezed
@HiveType(typeId: HiveTypeId.dishTemplate)
class DishTemplate with _$DishTemplate {
  const factory DishTemplate({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required int portions,
  }) = _DishTemplate;

  factory DishTemplate.fromJson(Map<String, dynamic> json) =>
      _$DishTemplateFromJson(json);

  static DishTemplate empty() => DishTemplate(id: '', title: '', portions: 0);
}