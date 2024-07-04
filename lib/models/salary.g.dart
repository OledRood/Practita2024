// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Salary _$SalaryFromJson(Map<String, dynamic> json) => Salary(
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$SalaryToJson(Salary instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'currency': instance.currency,
    };
