import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/booking.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> createBooking({required Booking booking});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final http.Client client;

  BookingRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<BookingModel>> getBookings() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookings}');
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookingModel> createBooking({required Booking booking}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bookings}');
    final bookingModel = booking is BookingModel ? booking : BookingModel.fromBooking(booking);
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bookingModel.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create booking: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return BookingModel.fromJson(data);
  }
}
