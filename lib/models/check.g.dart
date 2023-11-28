// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Check _$CheckFromJson(Map<String, dynamic> json) => Check(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? "New check",
    )..failOptions =
        (json['failOptions'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'failOptions': instance.failOptions,
    };
