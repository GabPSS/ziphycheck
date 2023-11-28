import 'package:checkup_app/models/identifiable_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check extends IdentifiableObject {
  String name;
  List<String> failOptions;

  Check({super.id = -1, required this.name, required this.failOptions});

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
  Map<String, dynamic> toJson() => _$CheckToJson(this);
}
