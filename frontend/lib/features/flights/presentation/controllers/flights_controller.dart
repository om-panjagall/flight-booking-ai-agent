import 'package:flutter/foundation.dart';

import '../../domain/entities/flights.dart';
import '../../domain/usecases/search_flights.dart';

class FlightsController extends ChangeNotifier {
  final SearchFlights searchFlights;

  FlightsController({
    required this.searchFlights,
  });

  List<Flight> flights = [];

  bool isLoading = false;

  String? errorMessage;

  Future<void> search({
    required String source,
    required String destination,
    required String date,
    required int adults,
  }) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      flights = await searchFlights(
        source: source,
        destination: destination,
        date: date,
        adults: adults,
      );
      debugPrint('FlightsController: found ${flights.length} flights');
    } catch (e) {
      flights = [];
      errorMessage = e.toString();
      debugPrint('FlightsController: search error: $e');
    }

    isLoading = false;

    notifyListeners();
  }
}