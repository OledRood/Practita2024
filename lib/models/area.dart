// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'area.g.dart';

@JsonSerializable()
class Area {
  final String id;

  Area({required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) =>
      Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
