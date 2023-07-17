// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location()
  ..name = json['name'] as String
  ..objects = (json['objects'] as List<dynamic>)
      .map((e) => CheckupObject.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'objects': instance.objects,
    };
