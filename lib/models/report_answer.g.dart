// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportAnswer _$ReportAnswerFromJson(Map<String, dynamic> json) => ReportAnswer(
      baseReportId: json['baseReportId'] as int,
    )
      ..id = json['id'] as int
      ..answerDate = DateTime.parse(json['answerDate'] as String)
      ..answers = (json['answers'] as List<dynamic>)
          .map((e) => TaskAnswer.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ReportAnswerToJson(ReportAnswer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baseReportId': instance.baseReportId,
      'answerDate': instance.answerDate.toIso8601String(),
      'answers': instance.answers,
    };
