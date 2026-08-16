import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/flight_model.dart';

class FlightService {
  final String baseUrl;

  FlightService({
    required this.baseUrl,
  });

  Future<List<FlightModel>> searchFlights({
    required String source,
    required String destination,
    required String date,
    required int adults,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/flights/search',
    ).replace(
      queryParameters: {
        'source': source,
        'destination': destination,
        'date': date,
        'adults': adults.toString(),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Flight search failed: ${response.statusCode}',
      );
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json
        .map(
          (item) => FlightModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}