// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parameters _$ParametersFromJson(Map<String, dynamic> json) => Parameters(
      salary: Salary.fromJson(json['salary'] as Map<String, dynamic>),
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      area: Area.fromJson(json['area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParametersToJson(Parameters instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'salary': instance.salary,
      'area': instance.area,
    };
