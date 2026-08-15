import 'package:flutter/foundation.dart';

class Booking {
  final String id;
  final String flightNumber;
  final String airline;
  final String passengerName;
  final String passengerEmail;
  final String passportNumber;
  final String departure;
  final String arrival;
  final String date;
  final String seatNumber;
  final int adults;
  final double totalPrice;
  final String status;

  const Booking({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.passengerName,
    required this.passengerEmail,
    required this.passportNumber,
    required this.departure,
    required this.arrival,
    required this.date,
    required this.seatNumber,
    required this.adults,
    required this.totalPrice,
    required this.status,
  });
}
