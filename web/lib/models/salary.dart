import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'salary.g.dart';

@JsonSerializable()
class Salary {
  final int? from;
  final int? to;
  final String currency;

  Salary(this.from, this.to, this.currency);
  factory Salary.fromJson(final Map<String, dynamic> json) =>
      _$SalaryFromJson(json);

  Map<String, dynamic> toJson() => _$SalaryToJson(this);
}
