import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'salary.g.dart';

@JsonSerializable()
class Salary {
  final int? from;
  final int? to;
  final String currency;

  Salary({
    required this.from,
    required this.to,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'currency': currency,
    };
  }

  factory Salary.fromMap(Map<String, dynamic> map) {
    return Salary(
      from: map['from'] != null ? map['from'] as int : null,
      to: map['to'] != null ? map['to'] as int : null,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Salary.fromJson(String source) =>
      Salary.fromMap(json.decode(source) as Map<String, dynamic>);
}
