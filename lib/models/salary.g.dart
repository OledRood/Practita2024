// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Salary _$SalaryFromJson(Map<String, dynamic> json) => Salary(
      (json['from'] as num?)?.toInt(),
      (json['to'] as num?)?.toInt(),
      json['currency'] as String,
    );

Map<String, dynamic> _$SalaryToJson(Salary instance) => <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'currency': instance.currency,
    };
