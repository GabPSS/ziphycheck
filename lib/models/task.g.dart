// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task()
  ..id = json['id'] as int
  ..name = json['name'] as String
  ..defaultFailOptions = (json['defaultFailOptions'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..answerPrompt = json['answerPrompt'] as String;

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'defaultFailOptions': instance.defaultFailOptions,
      'answerPrompt': instance.answerPrompt,
    };
