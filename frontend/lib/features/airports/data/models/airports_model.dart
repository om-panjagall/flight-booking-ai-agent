import '../../domain/entities/airports.dart';

class AirportModel extends Airport {
  const AirportModel({
    required super.id,
    required super.code,
    required super.name,
    required super.city,
    required super.country,
    required super.timezone,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      timezone: json['timezone'] as String,
    );
  }
}