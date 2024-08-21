// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'area.g.dart';

@JsonSerializable()
class Area {
  final String id;
  final String name;

  Area(this.name, {required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Area.fromJson(final Map<String, dynamic> json) =>
      _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}
