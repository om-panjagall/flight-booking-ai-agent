import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/airports_model.dart';

abstract class AirportsRemoteDataSource {
  Future<List<AirportModel>> getAirports();

  Future<AirportModel> getAirport(int id);
}

class AirportsRemoteDataSourceImpl
    implements AirportsRemoteDataSource {
  final http.Client client;

  AirportsRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<AirportModel>> getAirports() async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.airports}',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load airports: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (json) => AirportModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<AirportModel> getAirport(int id) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}'
        '${ApiConstants.airports}$id',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load airport: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    return AirportModel.fromJson(data);
  }
}