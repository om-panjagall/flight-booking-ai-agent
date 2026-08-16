import '../../domain/entities/airports.dart';
import '../../domain/repositories/airports_repository.dart';
import '../datasources/airports_remote_datasource.dart';

class AirportsRepositoryImpl implements AirportsRepository {
  final AirportsRemoteDataSource remoteDataSource;

  AirportsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Airport>> getAirports() {
    return remoteDataSource.getAirports();
  }

  @override
  Future<Airport> getAirport(int id) {
    return remoteDataSource.getAirport(id);
  }
}