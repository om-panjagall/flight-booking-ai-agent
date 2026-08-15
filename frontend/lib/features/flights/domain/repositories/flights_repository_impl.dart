import '../../domain/entities/flights.dart';
import '../../domain/repositories/flights_repository.dart';
import '../datasources/flights_remote_datasource.dart';

class FlightsRepositoryImpl implements FlightsRepository {
  final FlightsRemoteDataSource remoteDataSource;

  FlightsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Flight>> searchFlights({
    required String source,
    required String destination,
    required String date,
    required int adults,
  }) async {
    final flights = await remoteDataSource.searchFlights(
      source: source,
      destination: destination,
      date: date,
      adults: adults,
    );

    return flights.map<Flight>((m) => m).toList();
  }
}