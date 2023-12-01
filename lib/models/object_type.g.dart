// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectType _$ObjectTypeFromJson(Map<String, dynamic> json) => ObjectType(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? "Unnamed Object type",
    )..checkIds =
        (json['checkIds'] as List<dynamic>).map((e) => e as int).toList();

Map<String, dynamic> _$ObjectTypeToJson(ObjectType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'checkIds': instance.checkIds,
    };
