import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookings {
  final BookingRepository repository;

  GetBookings(this.repository);

  Future<List<Booking>> call() {
    return repository.getBookings();
  }
}

class CreateBooking {
  final BookingRepository repository;

  CreateBooking(this.repository);

  Future<Booking> call({required Booking booking}) {
    return repository.createBooking(booking: booking);
  }
}
