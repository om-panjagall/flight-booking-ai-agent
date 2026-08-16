import '../models/flight_model.dart';
import '../services/flight_service.dart';

class FlightsRemoteDataSource {
  final FlightService flightService;

  FlightsRemoteDataSource({
    required this.flightService,
  });

  Future<List<FlightModel>> searchFlights({
    required String source,
    required String destination,
    required String date,
    required int adults,
  }) async {
    return await flightService.searchFlights(
      source: source,
      destination: destination,
      date: date,
      adults: adults,
    );
  }
}