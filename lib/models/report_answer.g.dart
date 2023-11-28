// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportAnswer _$ReportAnswerFromJson(Map<String, dynamic> json) => ReportAnswer(
      id: json['id'] as int? ?? -1,
      reportId: json['reportId'] as int,
    )
      ..answerDate = DateTime.parse(json['answerDate'] as String)
      ..checkAnswers = (json['checkAnswers'] as List<dynamic>)
          .map((e) => CheckAnswer.fromJson(e as Map<String, dynamic>))
          .toList()
      ..locationAnswers = (json['locationAnswers'] as List<dynamic>)
          .map((e) => LocationAnswer.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ReportAnswerToJson(ReportAnswer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportId': instance.reportId,
      'answerDate': instance.answerDate.toIso8601String(),
      'checkAnswers': instance.checkAnswers,
      'locationAnswers': instance.locationAnswers,
    };
