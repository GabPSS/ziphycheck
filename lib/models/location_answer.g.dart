// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationAnswer _$LocationAnswerFromJson(Map<String, dynamic> json) =>
    LocationAnswer(
      locationId: json['locationId'] as int,
      status: json['status'] as bool,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$LocationAnswerToJson(LocationAnswer instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'status': instance.status,
      'notes': instance.notes,
    };
