import '../repositories/flights_repository.dart';

class GetFlightsUseCase {
  final FlightsRepository repository;

  GetFlightsUseCase({
    required this.repository,
  });

  Future<List<Flight>> call({
    required String source,
    required String destination,
    required String date,
    required int adults,
  }) {
    return repository.searchFlights(
      source: source,
      destination: destination,
      date: date,
      adults: adults,
    );
  }
}