import 'package:ziphycheck/models/identifiable_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check extends IdentifiableObject {
  String name;
  List<String> failOptions = List.empty(growable: true);

  Check({super.id = -1, this.name = "New check"});

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
  Map<String, dynamic> toJson() => _$CheckToJson(this);
}
