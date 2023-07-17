// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskAnswer _$TaskAnswerFromJson(Map<String, dynamic> json) => TaskAnswer(
      taskId: json['taskId'] as int,
      objectId: json['objectId'] as int,
    )
      ..status = json['status'] as bool
      ..failAnswerPrompt = json['failAnswerPrompt'] as String?
      ..notes = json['notes'] as String?
      ..photo = json['photo'] as String?;

Map<String, dynamic> _$TaskAnswerToJson(TaskAnswer instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'objectId': instance.objectId,
      'status': instance.status,
      'failAnswerPrompt': instance.failAnswerPrompt,
      'notes': instance.notes,
      'photo': instance.photo,
    };
