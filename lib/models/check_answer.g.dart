// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckAnswer _$CheckAnswerFromJson(Map<String, dynamic> json) => CheckAnswer(
      checkId: json['checkId'] as int?,
      objectId: json['objectId'] as int,
      status: json['status'] as bool? ?? false,
      photoReference: json['photoReference'] as String?,
    )..issues = (json['issues'] as List<dynamic>)
        .map((e) => Issue.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$CheckAnswerToJson(CheckAnswer instance) =>
    <String, dynamic>{
      'checkId': instance.checkId,
      'objectId': instance.objectId,
      'status': instance.status,
      'issues': instance.issues,
      'photoReference': instance.photoReference,
    };
