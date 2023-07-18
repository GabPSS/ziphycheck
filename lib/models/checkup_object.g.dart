// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkup_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckupObject _$CheckupObjectFromJson(Map<String, dynamic> json) =>
    CheckupObject()
      ..id = json['id'] as int
      ..name = json['name'] as String
      ..objectTypeId = json['objectTypeId'] as int?;

Map<String, dynamic> _$CheckupObjectToJson(CheckupObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'objectTypeId': instance.objectTypeId,
    };
