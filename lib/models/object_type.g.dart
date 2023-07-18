// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectType _$ObjectTypeFromJson(Map<String, dynamic> json) => ObjectType()
  ..id = json['id'] as int
  ..name = json['name'] as String
  ..taskIds = (json['taskIds'] as List<dynamic>).map((e) => e as int).toList()
  ..pluralName = json['pluralName'] as String;

Map<String, dynamic> _$ObjectTypeToJson(ObjectType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'taskIds': instance.taskIds,
      'pluralName': instance.pluralName,
    };
