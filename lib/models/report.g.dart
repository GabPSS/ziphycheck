// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['id'] as int? ?? -1,
      name: json['name'] as String,
    )
      ..locations = (json['locations'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList()
      ..checkupObjectKey = json['checkupObjectKey'] as int
      ..locationKey = json['locationKey'] as int;

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'locations': instance.locations,
      'checkupObjectKey': instance.checkupObjectKey,
      'locationKey': instance.locationKey,
    };
