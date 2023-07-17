// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataMaster _$DataMasterFromJson(Map<String, dynamic> json) => DataMaster()
  ..tasks = (json['tasks'] as List<dynamic>)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList()
  ..objectTypes = (json['objectTypes'] as List<dynamic>)
      .map((e) => ObjectType.fromJson(e as Map<String, dynamic>))
      .toList()
  ..reports = (json['reports'] as List<dynamic>)
      .map((e) => Report.fromJson(e as Map<String, dynamic>))
      .toList()
  ..reportAnswers = (json['reportAnswers'] as List<dynamic>)
      .map((e) => ReportAnswer.fromJson(e as Map<String, dynamic>))
      .toList()
  ..reportKey = json['reportKey'] as int
  ..objectTypeKey = json['objectTypeKey'] as int
  ..taskKey = json['taskKey'] as int
  ..reportAnswerKey = json['reportAnswerKey'] as int;

Map<String, dynamic> _$DataMasterToJson(DataMaster instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'objectTypes': instance.objectTypes,
      'reports': instance.reports,
      'reportAnswers': instance.reportAnswers,
      'reportKey': instance.reportKey,
      'objectTypeKey': instance.objectTypeKey,
      'taskKey': instance.taskKey,
      'reportAnswerKey': instance.reportAnswerKey,
    };
