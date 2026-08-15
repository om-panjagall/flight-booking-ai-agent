import '../entities/flights.dart';

abstract class FlightsRepository {
  Future<List<Flight>> searchFlights({
    required String source,
    required String destination,
    required String date,
    required int adults,
  });
}