import 'package:json_annotation/json_annotation.dart';
import 'package:web/models/area.dart';
import 'package:web/models/salary.dart';

part 'parameters.g.dart';

@JsonSerializable()
class Parameters {
  final String name;
  final int id;
  final Salary salary;
  final Area area;
  final String alternate_url;

  Parameters({
    required this.salary,
    required this.name,
    required this.id,
    required this.area,
    required this.alternate_url,
  });

  factory Parameters.fromJson(final Map<String, dynamic> json) =>
      _$ParametersFromJson(json);

  Map<String, dynamic> toJson() => _$ParametersToJson(this);
}
