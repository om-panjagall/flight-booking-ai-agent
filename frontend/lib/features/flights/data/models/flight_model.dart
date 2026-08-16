import '../../domain/entities/flights.dart';

class FlightModel extends Flight {
  const FlightModel({
    required super.flightNumber,
    required super.airline,
    required super.price,
    required super.duration,
    required super.availableSeats,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      flightNumber: json['flight_number'] ?? '',
      airline: json['airline'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] ?? '',
      availableSeats:
          (json['available_seats'] as num?)?.toInt() ?? 0,
    );
  }
}