// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSet _$DataSetFromJson(Map<String, dynamic> json) => DataSet()
  ..checks = (json['checks'] as List<dynamic>)
      .map((e) => Check.fromJson(e as Map<String, dynamic>))
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
  ..checkKey = json['checkKey'] as int
  ..objectTypeKey = json['objectTypeKey'] as int
  ..reportKey = json['reportKey'] as int
  ..reportAnswerKey = json['reportAnswerKey'] as int;

Map<String, dynamic> _$DataSetToJson(DataSet instance) => <String, dynamic>{
      'checks': instance.checks,
      'objectTypes': instance.objectTypes,
      'reports': instance.reports,
      'reportAnswers': instance.reportAnswers,
      'checkKey': instance.checkKey,
      'objectTypeKey': instance.objectTypeKey,
      'reportKey': instance.reportKey,
      'reportAnswerKey': instance.reportAnswerKey,
    };
