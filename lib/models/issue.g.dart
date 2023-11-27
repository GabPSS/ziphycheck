// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Issue _$IssueFromJson(Map<String, dynamic> json) => Issue(
      name: json['name'] as String,
      notes: json['notes'] as String?,
      solved: json['solved'] as bool? ?? false,
    );

Map<String, dynamic> _$IssueToJson(Issue instance) => <String, dynamic>{
      'name': instance.name,
      'notes': instance.notes,
      'solved': instance.solved,
    };
