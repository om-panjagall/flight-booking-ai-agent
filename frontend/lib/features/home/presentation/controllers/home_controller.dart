import 'package:flutter/foundation.dart';

import '../../../airports/domain/entities/airports.dart';
import '../../../airports/domain/usecases/get_airports.dart';
import '../../../flights/domain/entities/flights.dart';
import '../../../flights/domain/usecases/search_flights.dart';

class HomeController extends ChangeNotifier {
  final GetAirports getAirports;
  final SearchFlights searchFlights;

  HomeController({
    required this.getAirports,
    required this.searchFlights,
  });

  List<Airport> airports = [];

  List<Flight> flights = [];

  bool isLoadingAirports = false;
  bool isSearchingFlights = false;

  String? errorMessage;

  Future<void> loadAirports() async {
    isLoadingAirports = true;
    errorMessage = null;

    notifyListeners();

    try {
      airports = await getAirports();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingAirports = false;
      notifyListeners();
    }
  }

  Future<List<Flight>> search({
    required Airport source,
    required Airport destination,
    required DateTime date,
    required int adults,
  }) async {
    isSearchingFlights = true;
    errorMessage = null;

    notifyListeners();

    try {
      final dateString =
          '${date.year}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      flights = await searchFlights(
        source: source.code,
        destination: destination.code,
        date: dateString,
        adults: adults,
      );

      return flights;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isSearchingFlights = false;
      notifyListeners();
    }
  }
}