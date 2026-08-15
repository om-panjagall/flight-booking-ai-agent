import '../entities/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();
  Future<Booking> createBooking({required Booking booking});
}
