import '../entities/airports.dart';

abstract class AirportsRepository {
  Future<List<Airport>> getAirports();

  Future<Airport> getAirport(int id);
}