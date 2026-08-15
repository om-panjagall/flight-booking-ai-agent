import '../entities/airports.dart';
import '../repositories/airports_repository.dart';

class GetAirports {
  final AirportsRepository repository;

  GetAirports({
    required this.repository,
  });

  Future<List<Airport>> call() {
    return repository.getAirports();
  }
}