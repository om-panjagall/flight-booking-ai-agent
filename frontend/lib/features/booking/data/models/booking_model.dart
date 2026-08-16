import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.flightNumber,
    required super.airline,
    required super.passengerName,
    required super.passengerEmail,
    required super.passportNumber,
    required super.departure,
    required super.arrival,
    required super.date,
    required super.seatNumber,
    required super.adults,
    required super.totalPrice,
    required super.status,
  });

  factory BookingModel.fromBooking(Booking booking) {
    return BookingModel(
      id: booking.id,
      flightNumber: booking.flightNumber,
      airline: booking.airline,
      passengerName: booking.passengerName,
      passengerEmail: booking.passengerEmail,
      passportNumber: booking.passportNumber,
      departure: booking.departure,
      arrival: booking.arrival,
      date: booking.date,
      seatNumber: booking.seatNumber,
      adults: booking.adults,
      totalPrice: booking.totalPrice,
      status: booking.status,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      flightNumber: json['flight_number'] ?? json['flightNumber'] ?? '',
      airline: json['airline'] ?? '',
      passengerName: json['passenger_name'] ?? json['passengerName'] ?? '',
      passengerEmail: json['passenger_email'] ?? json['passengerEmail'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      date: json['date'] ?? json['booking_date'] ?? json['bookingDate'] ?? '',
      passportNumber: json['passport_number'] ?? json['passportNumber'] ?? '',
      seatNumber: json['seat_number'] ?? json['seatNumber'] ?? '',
      adults: (json['adults'] as num?)?.toInt() ?? 1,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? (json['fare'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? json['booking_status'] ?? 'confirmed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight_number': flightNumber,
      'airline': airline,
      'passenger_name': passengerName,
      'passenger_email': passengerEmail,
      'passport_number': passportNumber,
      'departure': departure,
      'arrival': arrival,
      'booking_date': date,
      'seat_number': seatNumber,
      'adults': adults,
      'fare': totalPrice,
      'booking_status': status,
    };
  }
}
